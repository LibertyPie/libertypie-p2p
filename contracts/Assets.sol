// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PermissionManager.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./PriceFeed.sol";

contract Assets is PermissionManager {

    /**
     * @dev mapping for  assetsData 
     */
    mapping(uint256 => AssetItem) internal  AssetsData;

    //set initially at 0, 
    //0 index wont be used due  to solidity behaviour over non existent data
    uint256 totalAssets;

    // assetsDataIndexes 
    // format mapping(assetContractAddress  => index )
    mapping(address => uint256) internal AssetsDataIndexes;

    /**
     * @dev asset struct item
     */
    struct AssetItem {
        string   symbol;
        string   name;
        address  contractAddress;
        uint8    decimals;
        string   tokenType;
        bool     isEnabled;
    }


    /**
     * @dev add an erc token  to assets
     */
    function _addERC20Token(address _contractAddress) internal {
        
        ERC20 erc20Token = ERC20(_contractAddress);

        //lets check if the  asset exists  first
        require(AssetsDataIndexes[_contractAddress] > 0,"An asset with the same contract address exist");

        AssetItem memory assetItem = AssetItem(
            erc20Token.symbol(),
            erc20Token.name(),
            _contractAddress,
             erc20Token.decimals(),
            "erc20",
            true
        );

        uint256 _index = totalAssets++;

        //lets insert the data 
        AssetsData[_index] = assetItem;

        AssetsDataIndexes[_contractAddress] = _index;
    }//end fun

     /**
     * @dev fetch asset by it contract address
     */
    function _getAsset(address _contractAddress) private  view returns (AssetItem memory) {
        
        uint256 assetIndex = AssetsDataIndexes[_contractAddress];

        require(assetIndex > 0,"Invalid  or unknown asset (bad index)");

        AssetItem memory assetItem = AssetsData[assetIndex];

        require(isValidAssetItem(assetItem),"Unknown or invalid asset");

        return assetItem;
    } //end function
 
    /**
     * @dev fetch asset by it contract address
     */
    function getAsset(address _contractAddress) external  view returns (
        string memory,
        string memory,
        address,
        uint8,
        string memory,
        bool
    ) {
       
       AssetItem memory asset = _getAsset(_contractAddress);

        return  (asset.symbol, asset.name, asset.contractAddress, asset.decimals, asset.tokenType, asset.isEnabled);

    } //end fun

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
     * @dev get all assets 
     */
     function getAllAssets() public view returns(AssetItem[] memory){

         AssetItem[] memory allAssetsDataArray;

         //indexes always  starts with 1, because the initial 0 index is incremented on first and every usage
         for(uint256 i = 1; i <= totalAssets; i++){

             //lets now get asset  info 
             AssetItem memory assetItem = AssetsData[i];

             if(isValidAssetItem(assetItem)){
                 allAssetsDataArray[i] = assetItem;
             }
         }

        return allAssetsDataArray;
     } //end fun


} //end class