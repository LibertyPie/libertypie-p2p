/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./PermissionManager/PM.sol";
import "./IStorage.sol";
import "./OfferStore.sol";

contract Storage is OfferStore {

    /**
     * @dev scalar values
     */

    //uint256 store 
    mapping(bytes32 => uint256) private uint256Store;

    //int store 
    mapping(bytes32 => int256) private int256Store;
     
    //string store 
    mapping(bytes32 => string) private stringStore;

    //bool store
    mapping(bytes32 => bool) private boolStore;

    //address store
    mapping(bytes32 => address) private addressStore;

    //bytes store
    mapping(bytes32 => bytes)    private bytesStore;

    /**
     * complex stores
     */
    mapping(bytes32 => address[]) addressArrayStore;
    mapping(bytes32 => bytes[])   bytesArrayStore;
    mapping(bytes32 => int256[])  int256ArrayStore;
    mapping(bytes32 => uint256[]) uint256ArrayStore;
    mapping(bytes32 => bool[])    boolArrayStore;
    mapping(bytes32 => string[])  stringArrayStore;


    /**
     * @dev set uint256  
     */
     function setUint256(bytes32 _key, uint256 _data) external {
        uint256Store[_key] = _data;
     }

    /**
     * @dev set int256  
     */
     function setInt256(bytes32 _key, int256 _data) external {
        int256Store[_key] = _data;
     }

    /**
     * @dev set string  
     */
     function setString(bytes32 _key, string calldata _data) external {
        int256Store[_key] = _data;
     }

    /**
     * @dev set boolean  
     */
     function setBool(bytes32 _key, bool _data) external {
        int256Store[_key] = _data;
     }

    /**
     * @dev set boolean  
     */
     function setBool(bytes32 _key, bool _data) external {
        boolStore[_key] = _data;
     }

    /**
     * @dev set address  
     */
     function setAddress(bytes32 _key, address _data) external {
        addressStorage[_key] = _data;
    }

    /**
     * @dev set address  
     */
     function setBytes(bytes32 _key, bytes _data) external {
        addressStorage[_key] = _data;
    }

    /**
     * get uint256
     */
    function getUint256(bytes32 _key) public view returns(uint256) {
        return uint256Store[_key];
    }

    /**
     * get int256
     */
    function getInt256(bytes32 _key) public view returns(int256) {
        return int256Store[_key];
    }

    /**
     * get int256
     */
    function getInt256(bytes32 _key) public view returns(int256) {
        return int256Store[_key];
    }

    /**
     * get bool
     */
    function getBool(bytes32 _key) public view returns(bool) {
        return boolStore[_key];
    }

     /**
     * get address
     */
    function getAddress(bytes32 _key) public view returns(address) {
        return addressStore[_key];
    }

    /**
     * get string
     */
    function getString(bytes32 _key) public view returns(string) {
        return stringStore[_key];
    }


    /**
     * complex types
     */

    // set uint256 array 
    function setUint256Array(bytes32 _key, uint256[] memory _data) external {
        uint256ArrayStore[_key] = _data;
    } 

    /**
     * add unit256 array item
     */
    function addUint256ArrayItem(bytes32 _key, uint256 _index, uint256 _value) external {
        uint256ArrayStore[_key][_index] = _value;
    } 

    //set int256 array
    function setInt256Array(bytes32 _key, int256[] memory _data) external {
        int256ArrayStore[_key] = _data;
    } 

    /**
     * add int256 array value
     */
    function addInt256ArrayItem(bytes32 _key, uint256 _index, int256 _value) external {
        int256ArrayStore[_key][_index] = _value;
    } 

     //set int256 array
    function setAddressArray(bytes32 _key, address[] memory _data) external {
        addressArrayStore[_key] = _data;
    } 

    //add address Array item
    function addAddressArrayItem(bytes32 _key, uint256 _index, address _value) external {
        addressArrayStore[_key][_index] = _value;
    } 

    //set string array
    function setStringArray(bytes32 _key, string[] memory _data) external {
        addressArrayStore[_key] = _data;
    } 

    //add string Array item
    function addStringArrayItem(bytes32 _key, uint256 _index, string calldata _value) external {
        stringArrayStore[_key][_index] = _value;
    } 

    //set bytes array
    function setBytesArray(bytes32 _key, bytes[] memory _data) external {
        bytesArrayStore[_key] = _data;
    } 

    //add bytes Array item
    function addBytesArrayItem(bytes32 _key, uint256 _index, bytes _value) external {
        bytesArrayStore[_key][_index] = _value;
    } 

}   