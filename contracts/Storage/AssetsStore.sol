/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/AssetsStructs.sol";


contract AssetsStore is StoreEditor  {

    //set initially at 0, 
    //0 index wont be used due  to solidity behaviour over non existent data
    uint256  private totalAssets;
    
    /**
     * @dev mapping for  assetsData 
     */
    mapping(uint256 => AssetsStructs.AssetItem) private  AssetsData;

    // assetsDataIndexes 
    // format mapping(assetContractAddress  => index )
    mapping(address => uint256) private AssetsDataIndexes;


    /**
     * get the next asset id
     */
    function getNextAssetId() external onlyStoreEditor returns(uint256) {
        return (totalAssets += 1);
    }

    /**
     * get total assets
     */
    function getTotalAssets() external view returns (uint256) {
        return totalAssets;
    }

    /**
     * @dev saveAssetData
     * @param _id asset id
     * @param _data asset data 
     */
    function saveAssetData(uint256 _id, AssetsStructs.AssetItem memory _data) external onlyStoreEditor {
        AssetsData[_id] = _data;
        AssetsDataIndexes[_data.contractAddress] = _id;
    } //end fun 


    /**
     * @dev get asset data
     * @param _id asset id
     */
    function getAssetData(uint256 _id) external view returns(AssetsStructs.AssetItem memory) {
        return AssetsData[_id];
    } //end fun 


    /**
     * @dev get assetData by address
     */
    function getAssetIdByAddress(address _address) public view returns (uint256) {
        return AssetsDataIndexes[_address];
    } //end fun 
    
    /**
    * @dev getAssetDataByAddress
    * @param _address asset address
    */
    function getAssetDataByAddress(address _address) external view returns (AssetsStructs.AssetItem memory) {
        return AssetsData[getAssetIdByAddress(_address)];
    }
    
}
