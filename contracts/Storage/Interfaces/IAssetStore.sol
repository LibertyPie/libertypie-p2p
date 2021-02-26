/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../../Commons/AssetsStructs.sol";

interface IAssetStore {

    function getNextAssetId() external returns(uint256);
    function getTotalAssets() external view returns (uint256);
    function saveAssetData(uint256 _id,AssetsStructs.AssetItem _data) external; 
    function getAssetIdByAddress(address _address) public view returns (uint256);
    function getAssetDataByAddress(address _address) external view returns (AssetsStructs.AssetItem memory);

}