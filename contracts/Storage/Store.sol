/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;

import "../PermissionManager/PM.sol";
import "./IStorage.sol";

contract Store is PM {
    
    /**
     * Store address
     */
     Storage public _storageAddr;

    /**
     * setStorage
     */
     function setStorage(Storage _addr) external isSuperAdmin {
        _storageAddr = _addr;
     }

    function() external  {

        assembly {

          let ptr := mload(0x40)

            calldatacopy(ptr, 0, calldatasize)

            let result := call(gas, _storageAddr, ptr, calldatasize, 0, 0)
            let size := returndatasize

            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }

        }
    }
}