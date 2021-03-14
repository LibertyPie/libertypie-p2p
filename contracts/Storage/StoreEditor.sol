
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

contract StoreEditor is PM {

     //permissions 
    modifier onlyStoreEditor() {

      address _caller;
      assembly { _caller := caller() }

      //note, this must be the contract address 
      require(PERMISSION_MANAGER.isStorageEditor(_caller),"ONLY_STORAGE_EDITORS_ALLOWED");
      _;
    }
}