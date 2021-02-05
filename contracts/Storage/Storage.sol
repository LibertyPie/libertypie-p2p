/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./PermissionManager/PM.sol";
import "./IStorage.sol";

contract Storage {

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
    mapping(bytes32 => bytes)    private addressStorage;

    /**
     * complex stores
     */
    mapping(bytes32 => address[]) addressArrayStore;
    mapping(bytes32 => bytes[])   bytesArrayStore;
    mapping(bytes32 => int256[])  int256ArrayStore;
    mapping(bytes32 => uint256[]) uint256ArrayStore;
    mapping(bytes32 => bool[])    boolArrayStore;


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
     function setString(bytes32 _key, string _data) external {
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
        int256Store[_key] = _data;
     }

    /**
     * @dev set address  
     */
     function setAddress(bytes32 _key, address _data) external {
        int256Store[_key] = _data;
     }
}