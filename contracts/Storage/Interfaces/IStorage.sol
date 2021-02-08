
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

interface IStorage {

    /**
     * Basic Store setters
     */
    function setUint256(bytes32 _key, uint256 _data) external;
    function setInt256(bytes32 _key, int256 _data) external;
    function setString(bytes32 _key, string calldata _data) external;
    function setBool(bytes32 _key, bool _data) external;
    function setBool(bytes32 _key, bool _data) external;
    function setAddress(bytes32 _key, address _data) external;
    function setBytes(bytes32 _key, bytes memory _data) external;

    /**
     * Basic store getters
     */
    function getUint256(bytes32 _key) public view returns(uint256);
    function getInt256(bytes32 _key) public view returns(int256);
    function getInt256(bytes32 _key) public view returns(int256);
    function getBool(bytes32 _key) public view returns(bool);
    function getAddress(bytes32 _key) public view returns(address);
    function getString(bytes32 _key) public view returns(string memory);


    /**
     * Complex Store Setters
     */
    function setUint256Array(bytes32 _key, uint256[] memory _data) external;
    function addUint256ArrayItem(bytes32 _key, uint256 _index, uint256 _value) external;
    function setInt256Array(bytes32 _key, int256[] memory _data) external;
    function addInt256ArrayItem(bytes32 _key, uint256 _index, int256 _value) external;
    function setAddressArray(bytes32 _key, address[] memory _data) external;
    function addAddressArrayItem(bytes32 _key, uint256 _index, address _value) external;
    function setStringArray(bytes32 _key, string[] memory _data) external;
    function addStringArrayItem(bytes32 _key, uint256 _index, string calldata _value) external;
    function setBytesArray(bytes32 _key, bytes[] memory _data) external;
    function addBytesArrayItem(bytes32 _key, uint256 _index, bytes memory _value) external;
}