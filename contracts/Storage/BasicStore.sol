
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";

contract BasicStore is StoreEditor {

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
    mapping(bytes32 => bytes) private bytesStore;

     //mapping store
    // key => mapping
    mapping(bytes32 => mapping(bytes32 => bytes)) private mappingStore;

    // nested mapping store 
    mapping(bytes32 => mapping(bytes32 => mapping(bytes32 => bytes))) private nestedMappingStore;

    /**
     * Setters
     */

    /**
     * @dev set uint256  
     */
     function setUint256(bytes32 _key, uint256 _data) external  onlyStoreEditor {
        uint256Store[_key] = _data;
     }

    /**
     * @dev increment uint256 this adds a +1 to the exiting data
     */
     function incrementUint256(bytes32 _key) external  onlyStoreEditor returns(uint256) {
        uint256Store[_key] += 1;
     }

    /**
     * @dev set int256  
     */
     function setInt256(bytes32 _key, int256 _data) external  onlyStoreEditor {
        int256Store[_key] = _data;
     }

    /**
     * @dev set string  
     */
     function setString(bytes32 _key, string calldata _data) external onlyStoreEditor {
        stringStore[_key] = _data;
     }

    /**
     * @dev set boolean  
     */
     function setBool(bytes32 _key, bool _data) external onlyStoreEditor {
        boolStore[_key] = _data;
     }

    /**
     * @dev set address  
     */
     function setAddress(bytes32 _key, address _data) external onlyStoreEditor {
        addressStore[_key] = _data;
    }

    /**
     * @dev set bytes data  
     */
     function setBytes(bytes32 _key, bytes memory _data) external onlyStoreEditor {
        bytesStore[_key] = _data;
    }

    /**
     * Getters 
     */

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
    function getString(bytes32 _key) public view returns(string memory) {
        return stringStore[_key];
    }
}