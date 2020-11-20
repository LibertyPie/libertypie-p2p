// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./PriceFeed.sol";

contract Assets is PM {

    PriceFeed _priceFeed = PriceFeed(address(this));

    /**
     * @dev mapping for  assetsData 
     */
    mapping(uint256 => AssetItem) internal  AssetsData;

    //set initially at 0, 
    //0 index wont be used due  to solidity behaviour over non existent data
    uint256  private totalAssets;

    // assetsDataIndexes 
    // format mapping(assetContractAddress  => index )
    mapping(address => uint256) internal AssetsDataIndexes;

    /**
     * @dev asset struct item
     */
    struct AssetItem {
        uint256  index;
        string   symbol;
        string   name;
        address  contractAddress;
        uint8    decimals;
        bool     isPegged;
        string   originalName;
        string   originalSymbol;
        address  wrapperContract;
        bool     isEnabled;
        uint256  createdAt;
        uint256  updatedAt;
    }


    /**
     * @dev add a new asset to supported list
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     */
    function _addAsset(
        address _contractAddress, 
        bool    _isPegged,
        string memory  _originalName,
        string memory _originalSymbol,
        address _wrapperContract
    ) private {
        
        //fetch contract  info
        ERC20 erc20Token = ERC20(_contractAddress);

         if(bytes(_originalName).length == 0){
            _originalName  = erc20Token.name();
        }


        if(bytes(_originalSymbol).length == 0){
            _originalSymbol  = erc20Token.symbol();
        }
        
        uint256 _index = totalAssets++;

        AssetItem memory assetItem = AssetItem(
            _index,
            erc20Token.symbol(),
            erc20Token.name(),
            _contractAddress,
            erc20Token.decimals(),
            _isPegged,
            _originalName,
            _originalSymbol,
            _wrapperContract,
            true,
            block.timestamp,
            block.timestamp
        );


        //lets insert the data 
        AssetsData[_index] = assetItem;

        AssetsDataIndexes[_contractAddress] = _index;

    }//end fun


     /**
     * @dev add a new asset to supported list
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     */
    function addAsset(
        address _contractAddress, 
        bool    _isPegged,
        string calldata  _originalName,
        string calldata  _originalSymbol,
        address _wrapperContract
    ) external onlyAdmins() {
        return _addAsset(_contractAddress, _isPegged, _originalName, _originalSymbol, _wrapperContract);
    }
        

     /**
     * @dev fetch asset by it contract address
     * @param _contractAddress asset's contract address
     * @return AssetItem
     */
    function getAsset(address _contractAddress) public  view returns (AssetItem memory) {
        
        uint256 assetIndex = AssetsDataIndexes[_contractAddress];

        AssetItem memory assetItem = AssetsData[assetIndex];

        require(isValidAssetItem(assetItem),"XPIE:UNKNOWN_ASSET");

        return assetItem;
    } //end function


    /**
     * @dev unstructure the asset item to tuple
     */
     function destructAssetItem(AssetItem memory _asset) private pure returns(
        uint256, string memory, string memory, address, uint8, bool, string memory, string memory  
     ) {
         return ( _asset.index, _asset.name, _asset.symbol, _asset.contractAddress, _asset.decimals, _asset.isPegged, _asset.originalSymbol, _asset.originalSymbol );
     }



    /**
     * @dev check if the asset is valid or enabled 
     */
    function isValidAssetItem(AssetItem memory assetItem) pure internal  returns(bool){
        return (
            bytes(assetItem.symbol).length > 0 &&
            assetItem.contractAddress != address(0) && 
            assetItem.isEnabled == true
        );
    }


    /**
     * @dev is the provided asset contract supported
     *  @param _contractAddress  asset contract address
     */
     function isAssetSupported(address _contractAddress) public  view returns(bool) {

         AssetItem  memory asset = getAsset(_contractAddress);

         return isValidAssetItem(asset);
     }


    /**
     * @dev get all assets 
     */
     function getAllAssets() public view returns(AssetItem[] memory){

         AssetItem[] memory allAssetsDataArray  = new AssetItem[]  (totalAssets);

         //loop to get items
         // ids never starts  with  0, so start with  1
         for(uint256 i = 0; i <= totalAssets; i++){

             //lets now get asset  info 
             AssetItem memory assetItem = AssetsData[i];

             if(isValidAssetItem(assetItem)){
                allAssetsDataArray[i] = assetItem;
             }
         }

        return allAssetsDataArray;
     } //end fun


} //end class