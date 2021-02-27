/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "./Storage/StoreProxy.sol";


contract Config is PM {
    
    Istore _configDataStore = IStorage _dataStore = StoreProxy(address(this)).getIStorage();

    /**
     * get config
     * @param _key config key 
     */ 
    geConfig(string _key) public view returns(bytes32) {
        return _configDataStore.getConfigData(keccak256(_key));
    }

    /**
     * setConfig
     * @param _key config key
     * @param _value cofig data
     */
    function setConfig(bytes32 _key, bytes32 _value) public adminOnly() {
        _configDataStore.addConfigData(_key, _value);
    }

    /**
     * get all config data
     */
    function getAllConfigs() external view returns(bytes32[] memory, bytes32[] memory) {
        return  _configDataStore.getAllConfigData();
    }

}