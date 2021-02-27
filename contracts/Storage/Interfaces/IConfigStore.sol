/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

interface IConfigStore {

    function getConfigData(bytes32 _key) public view returns (bytes32);
    function addConfigData(bytes32 _key, bytes32 _value) external;
    function getAllConfigData() external view returns (bytes32[] memory, bytes32[] memory);
    
}