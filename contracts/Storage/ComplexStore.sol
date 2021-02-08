
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./StoreEditor.sol";

contract ComplexStore is StoreEditor {
    /**
     * complex stores
     */
    mapping(bytes32 => address[]) private addressArrayStore;
    mapping(bytes32 => bytes[])   private  bytesArrayStore;
    mapping(bytes32 => int256[])  private int256ArrayStore;
    mapping(bytes32 => uint256[]) private uint256ArrayStore;
    mapping(bytes32 => bool[])    private boolArrayStore;
    mapping(bytes32 => string[])  private  stringArrayStore;


    // set uint256 array 
    function setUint256Array(bytes32 _key, uint256[] memory _data) external onlyStoreEditor {
        uint256ArrayStore[_key] = _data;
    } 

    /**
     * add unit256 array item
     */
    function addUint256ArrayItem(bytes32 _key, uint256 _index, uint256 _value) external onlyStoreEditor {
        uint256ArrayStore[_key][_index] = _value;
    } 

    //set int256 array
    function setInt256Array(bytes32 _key, int256[] memory _data) external onlyStoreEditor {
        int256ArrayStore[_key] = _data;
    } 

    /**
     * add int256 array value
     */
    function addInt256ArrayItem(bytes32 _key, uint256 _index, int256 _value) external onlyStoreEditor {
        int256ArrayStore[_key][_index] = _value;
    } 

     //set int256 array
    function setAddressArray(bytes32 _key, address[] memory _data) external onlyStoreEditor {
        addressArrayStore[_key] = _data;
    } 

    //add address Array item
    function addAddressArrayItem(bytes32 _key, uint256 _index, address _value) external onlyStoreEditor {
        addressArrayStore[_key][_index] = _value;
    } 

    //set string array
    function setStringArray(bytes32 _key, string[] memory _data) external onlyStoreEditor {
        addressArrayStore[_key] = _data;
    } 

    //add string Array item
    function addStringArrayItem(bytes32 _key, uint256 _index, string calldata _value) external onlyStoreEditor {
        stringArrayStore[_key][_index] = _value;
    } 

    //set bytes array
    function setBytesArray(bytes32 _key, bytes[] memory _data) external onlyStoreEditor {
        bytesArrayStore[_key] = _data;
    } 

    //add bytes Array item
    function addBytesArrayItem(bytes32 _key, uint256 _index, bytes memory _value) external onlyStoreEditor {
        bytesArrayStore[_key][_index] = _value;
    } 

}