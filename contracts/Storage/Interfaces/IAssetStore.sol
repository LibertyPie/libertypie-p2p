/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "../../Commons/AssetsStructs.sol";

interface IAssetStore {

    function getNextAssetId() external returns(uint256);
    function getTotalAssets() external view returns (uint256);
    function saveAssetData(uint256 _id,AssetsStructs.AssetItem memory _data) external; 
    function getAssetData(uint256 _id) external view returns(AssetsStructs.AssetItem memory);
    function getAssetIdByAddress(address _address) external view returns (uint256);
    function getAssetDataByAddress(address _address) external view returns (AssetsStructs.AssetItem memory);

}