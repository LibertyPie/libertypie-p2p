/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

//import "./PermissionManager/PM.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "./Storage/StoreProxy.sol";
import "./Commons/AssetsStructs.sol";
import "./Base.sol";
import "./PriceFeeds/PriceFeed.sol";

contract Assets is Base {

    //events 
    event AddAsset(uint256 id);
    event UpdateAsset(uint256 id);

    //store Proxy
    ////IStorage getDataStore() = StoreProxy(address(this)).getIStorage();

    //initiate price feed
    PriceFeed _priceFeed = PriceFeed(address(this));

     /**
     * @dev add a new asset to supported list
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     * @param isEnabled if contract is enabled
     */
    function addAsset(
        address  _contractAddress, 
        bool     _isPegged,
        string   memory  _originalName,
        string   memory _originalSymbol,
        address _wrapperContract,
        string memory _priceFeedProvider,
        address _priceFeedContract,
        bool    isEnabled
    ) public onlyAdmin {

        require(_contractAddress != address(0), statusMsg("INAVLID_CONTRACT_ADDRESS"));

        require(_priceFeedContract != address(0), statusMsg("INAVLID_PRICE_FEED_CONTRACT_ADDRESS"));

         
      require(toBytes32(_priceFeedProvider) == toBytes32("chainlink") || 
         toBytes32(_priceFeedProvider) == toBytes32("open_price_feed"),
         statusMsg("UNKNOWN_PRICE_FEED_PROVIDER",_priceFeedProvider)
      );

        
        //fetch contract  info
        ERC20 erc20Token = ERC20(_contractAddress);

        uint256 _id = getDataStore().getNextAssetId();

        AssetsStructs.AssetItem memory assetItem = AssetsStructs.AssetItem(
            _id,
            _contractAddress,
            erc20Token.decimals(),
            _isPegged,
            _originalName,
            _originalSymbol,
            _wrapperContract,
            _priceFeedProvider,
            _priceFeedContract,
            isEnabled,
            block.timestamp,
            block.timestamp
        );

        _priceFeed.setAssetPriceFeedContract(erc20Token.symbol(), _priceFeedContract);
        
        // lets save the data
        getDataStore().saveAssetData(_id, assetItem);

        emit AddAsset(_id);
    }//end fun


    /**
     * @dev add a new asset to supported list
     * @param _id asset Id
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     * @param isEnabled if contract is enabled
     */
    function updateAsset(
        uint256  _id,
        address  _contractAddress, 
        bool     _isPegged,
        string   memory  _originalName,
        string   memory _originalSymbol,
        address _wrapperContract,
        string memory _priceFeedProvider,
        address _priceFeedContract,
        bool    isEnabled
    )  public onlyAdmin {

        
        require(_contractAddress != address(0), statusMsg("INAVLID_CONTRACT_ADDRESS"));

        require(_priceFeedContract != address(0), statusMsg("INAVLID_PRICE_FEED_CONTRACT_ADDRESS"));

        require(_id > 0, statusMsg("INVALID_ASSET_ID"));

        //lets get the assetInfo
        AssetsStructs.AssetItem memory assetInfo = getAssetById(_id);


          //fetch contract  info
        ERC20 erc20Token = ERC20(_contractAddress);

        AssetsStructs.AssetItem memory assetItem = AssetsStructs.AssetItem(
            _id,
            _contractAddress,
            erc20Token.decimals(),
            _isPegged,
            _originalName,
            _originalSymbol,
            _wrapperContract,
            _priceFeedProvider,
            _priceFeedContract,
            isEnabled,
            assetInfo.createdAt,
            block.timestamp
        );

        _priceFeed.setAssetPriceFeedContract(erc20Token.symbol(), _priceFeedContract);
        
        // lets save the data
        getDataStore().saveAssetData(_id, assetItem);

        emit UpdateAsset(_id);
    }//end 
   
    /**
     * @dev fetch asset by it contract address
     * @param _contractAddress asset's contract address
     * @return AssetsStructs.AssetItem
     */
    function getAsset(address _contractAddress) public  view returns (AssetsStructs.AssetItem memory) {
        
        //first lets get the index
        uint256 assetId = getDataStore().getAssetIdByAddress(_contractAddress);


        //this lets check if id isnt 0
        require(assetId > 0, "XPIE:UNKNOWN_ASSET");


        //lets get asset info by id
        AssetsStructs.AssetItem memory assetData = getAssetById(assetId);

        //is asset enabled, if not disabled 
        require(assetData.isEnabled == true,"XPIE:ASSET_NOT_ENABLED");
        
        return assetData;
    } //end 


    /**
     * @dev getAssetById
     * @param _id asset id
     */
    function getAssetById(uint256 _id) public view returns (AssetsStructs.AssetItem memory) {
        return getDataStore().getAssetData(_id);
    }


    /**
     * @dev check if the asset is valid or enabled 
     */
    function isValidAssetItem(AssetsStructs.AssetItem memory assetItem) pure internal  returns(bool){
        return (
            assetItem.contractAddress != address(0) && 
            assetItem.isEnabled == true
        );
    }

    /**
     * isValidAsset using id
     * @param _id asset id
     */
    function isValidAssetItem(uint256 _id) public view returns(bool) {
        return isValidAssetItem(getAssetById(_id));
    }


    /**
     * @dev is the provided asset contract supported
     *  @param _contractAddress  asset contract address
     */
     function isAssetSupported(address _contractAddress) public  view returns(bool) {
         return isValidAssetItem(getAsset(_contractAddress));
     }


    /**
     * @dev get all assets 
     */
     function getAllAssets() public view returns(AssetsStructs.AssetItem[] memory){

        uint256 totalAssets = getDataStore().getTotalAssets();

        AssetsStructs.AssetItem[] memory assetsData  = new AssetsStructs.AssetItem[]  (totalAssets);

         //loop to get items
         // ids never starts  with  0, so start with  1
        for(uint256 i = 0; i <= totalAssets; i++){

             //lets now get asset  info 
            AssetsStructs.AssetItem memory assetItem = getAssetById(i);

            if(isValidAssetItem(assetItem)){
                assetsData[i] = assetItem;
            }
        }

        return assetsData;
     } //end fun


} //end contract