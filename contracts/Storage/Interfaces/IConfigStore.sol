/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "../../Commons/ConfigsStructs.sol";


interface IConfigStore {

    function getConfigData(string memory _key) external view returns (bytes32);
    function addConfigData(string memory _key, bytes32 _value) external;
    function getAllConfigData() external view returns (ConfigsStructs.ConfigItem[] memory);

}