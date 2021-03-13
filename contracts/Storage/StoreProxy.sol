/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.7.6;

import "../PermissionManager/PM.sol";
import "./Interfaces/IStorage.sol";

contract StoreProxy is PM {
    
    /**
     * Store address
     */
     address public STORAGE_ADDRESS;


     /**
      * @dev this returns an instance of he same contract
      */
      function getIStorage() public view returns(IStorage) {
          return IStorage(address(this));
      }


    /**
     * setStorage
     */
     function setStorage(address _address) external onlySuperAdmin {
        require(_address != address(0),"XPIE:VALID_STORAGE_ADDRESS_REQUIRED");
        STORAGE_ADDRESS = _address;
     }
    
    /*
    fallback() external {
        
        address _target = STORAGE_ADDRESS;

        assembly {

            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := call(gas(),0, _target, ptr, calldatasize(), 0, 0)
            
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }

        } //end assembly
        
    } //end fallback 
    */
}