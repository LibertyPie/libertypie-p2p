/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;

import "../PermissionManager/PM.sol";
import "./Interfaces/IStorage.sol";

contract StoreProxy is PM {
    
    /**
     * Store address
     */
     address public _storageAddr;


     /**
      * getStoreImpl
      */
      function getIStorage() public view returns(IStorage) {
          return IStorage(address(this));
      }


    /**
     * setStorage
     */
     function setStorage(address _addr) external onlySuperAdmin {
        require(_addr != address(0),"VALID_STORAGE_ADDRESS_REQUIRED");
        _storageAddr = _addr;
     }
    
    function _fallback() private {
        
        address _target = _storageAddr;

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


    fallback() external {
        _fallback();
    }

}