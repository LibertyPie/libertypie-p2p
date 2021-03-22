/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/ConfigsStructs.sol";

contract ConfigStore is StoreEditor  {

    //total Config
    uint256 public totalEntries;

    //config 
    mapping(string => bytes32) private configData;
    
    //config indexes
    mapping(uint256 => string) private configKeyMap;

    
    /**
     * @dev get config data
     * @param _key a byte32 key
     */
    function getConfigData(string memory _key) public view returns (bytes32){
        return configData[_key];
    }

    /**
     * @dev get all config data
     */
    function addConfigData(string memory _key, bytes32 _value) external onlyStoreEditor {
        configData[_key] = _value;
        configKeyMap[++totalEntries] = _key;
    } //end fun


    /**
    * allConfigData
    */
    function getAllConfigData() public view returns (ConfigsStructs.ConfigItem[] memory) {
        

       ConfigsStructs.ConfigItem[]  memory configsArray = new ConfigsStructs.ConfigItem[](totalEntries + 1);

        for(uint256 i = 1; i <= totalEntries; i++){
            string memory _key = configKeyMap[i];
            if(bytes(_key).length > 0){ configsArray[i] = ConfigsStructs.ConfigItem(_key,configData[_key]); }
        }

        return configsArray;
    } //end fun

    
}