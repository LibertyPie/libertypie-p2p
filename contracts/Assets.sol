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

contract Assets is Base {

    //events 
    event AddAsset(uint256 id);

    //store Proxy
    ////IStorage _dataStore = StoreProxy(address(this)).getIStorage();

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
        address priceContract,
        bool    isEnabled
    ) private {

        require(_contractAddress != address(0), statusMsg("INAVLID_CONTRACT_ADDRESS"));
        
        //fetch contract  info
        ERC20 erc20Token = ERC20(_contractAddress);

        uint256 _id = _dataStore.getNextAssetId();

        AssetsStructs.AssetItem memory assetItem = AssetsStructs.AssetItem(
            _id,
            _contractAddress,
            erc20Token.decimals(),
            _isPegged,
            _originalName,
            _originalSymbol,
            _wrapperContract,
            isEnabled,
            block.timestamp,
            block.timestamp
        );


        // lets save the data
        _dataStore.saveAssetData(_id, assetItem);

        emit AddAsset(_id);
    }//end fun
   
    /**
     * @dev fetch asset by it contract address
     * @param _contractAddress asset's contract address
     * @return AssetsStructs.AssetItem
     */
    function getAsset(address _contractAddress) public  view returns (AssetsStructs.AssetItem memory) {
        
        //first lets get the index
        uint256 assetId = _dataStore.getAssetIdByAddress(_contractAddress);


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
        return _dataStore.getAssetData(_id);
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
    function isValidAssetItem(uint256 _id) external view returns(bool) {
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

        uint256 totalAssets = _dataStore.getTotalAssets();

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