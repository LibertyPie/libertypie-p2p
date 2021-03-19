/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.7.6;

import "../PermissionManager/PM.sol";
//import "./Storage.sol";
import "./Interfaces/IStorage.sol";

contract DataStore is PM {
  
    event SetStorage(address indexed _contractAddress);

    /**
     * Store address
     */
     IStorage public STORAGE_CONTRACT;

     bool dataStoreInitialized;

    //initialize data store 
    function initializeDataStore(address _storageContract) internal {

        require(!dataStoreInitialized, "DATASTORE_ALREADY_INITIALIZED");
        require(_storageContract != address(0),"XPIE:VALID_STORAGE_ADDRESS_REQUIRED");

        STORAGE_CONTRACT = IStorage(_storageContract);

        emit SetStorage(_storageContract);

        dataStoreInitialized = true;
    } //end fun

    /**
    * @dev this returns an instance of he same contract
    */
    function getDataStore() public view returns(IStorage) {
        return STORAGE_CONTRACT;
    }

    /**
     * setStorage
     */
     function setStorage(address _storageContract) external onlySuperAdmin {
        
        require(_storageContract != address(0),"XPIE:VALID_STORAGE_ADDRESS_REQUIRED");
        
        STORAGE_CONTRACT = IStorage(_storageContract);

        emit SetStorage(_storageContract);
     }
        
}