/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.7.6;

import "../PermissionManager/PM.sol";
import "./Storage.sol";

contract DataStore is PM {
  
    
    /**
     * Store address
     */
     address public STORAGE_CORE_ADDRESS;


    /**
     * @dev install the storage contract
     */
     constructor() {
         STORAGE_CORE_ADDRESS = address(new Storage());
     }


    /**
    * @dev this returns an instance of he same contract
    */
    function getStore() internal view returns(IStorage) {
        return IStorage(STORAGE_CORE_ADDRESS);
    }


    /**
     * setStorage
     */
     function setStorage(address _address) external onlySuperAdmin {
        require(_address != address(0),"XPIE:VALID_STORAGE_ADDRESS_REQUIRED");
        STORAGE_ADDRESS = _address;
     }
        
}