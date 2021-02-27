/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/ConfigsStructs.sol";

contract ConfigStore is StoreEditor  {

    //total Config
    uint256 totalEntries;

    //config 
    mapping(uint256 => bytes32) private configData;
    
    //config indexes
    mapping(bytes32 => uint256) private ConfigKeysToIdsMap;

    mapping(uint32 => bytes32) private ConfigIdsToKeysMap;
    
    /**
     * @dev get config data
     * @param _key a byte32 key
     */
    function getConfigData(bytes32 _key) public view returns (bytes32){
        uint256 index = configKeys[_key];
        require(index > 0, "XPIE:UNKNOWN_KEY");
        return configData[index];
    }

    /**
     * @dev get all config data
     */
    function addConfigData(bytes32 _key, bytes32 _value) external onlyStoreEditor {

        uint256 _id = ++totalEntries;

        configData[_id] = _value;

        //lets save the key first
        ConfigKeysToIdsMap[_key] = _id;

        ConfigIdsToKeysMap[_id] = _key;
    } //end fun


    /**
    * allConfigData
    */
    function getAllConfigData() external view returns (ConfigsStructs.ConfigItem[] memory) {

        ConfigsStructs.ConfigItem[] configsArray = new ConfigsStructs.ConfigItem[totalEntries];

        for(uint256 i = 1; i <= totalEntries; i++){
            configsArray[i] = ConfigsStructs.ConfigItem(ConfigIdsToKeysMap[i],configData[i]);
        }

        return configsArray;
    } //end fun

    
}