/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "./Commons/ConfigsStructs.sol";
import "./Utils.sol";
//import "./Storage/Interfaces/IStorage.sol";
import "./Storage/DataStore.sol";

contract Config is PM, Utils, DataStore {

    /**
     * get config
     * @param _key config key 
     */ 
    function getConfig(string memory _key) public view returns(bytes32) {
        return getDataStore().getConfigData(_key);
    }

    
    /**
     * setConfig
     * @param _key config key
     * @param _value cofig data
     */
    function setConfigData(string memory _key, bytes32 _value) public onlyAdmin {
        getDataStore().addConfigData(_key, _value);
    }

    /**
     * setConfigDataBulk
     */
    function setConfigDataBulk(ConfigsStructs.ConfigItem[] memory _data) public onlyAdmin {
        for(uint i = 0; i <= _data.length; i++){
            getDataStore().addConfigData(_data[i]._key, _data[i]._value);
        }
    } 

    /**
     * get all config data
     */
    function getAllConfigs() public view returns (ConfigsStructs.ConfigItem[] memory){
       return  getDataStore().getAllConfigData();
    }

}