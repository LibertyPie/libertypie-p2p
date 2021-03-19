
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

interface IPERMISSION_MANAGER {
    function hasRole(string memory roleName, address _address) external view returns(bool);
}

contract StoreEditor {

    bool isStoreEditorInitialized;
    
    IPERMISSION_MANAGER _permissionManager; 

    string STORAGE_EDITOR_ROLE = "STORAGE_EDITOR";


    function setPermissionManager(address _contractAddress) internal {

        require(!isStoreEditorInitialized,"XPIE:STORE_EDITOR_ALREADY_INITIALIZED");

        _permissionManager = IPERMISSION_MANAGER(_contractAddress);

        isStoreEditorInitialized = true;
    }

     //permissions 
    modifier onlyStoreEditor() {
        
        address _caller;
        assembly { _caller := caller() }

       //note, this must be the calling's contract address  PERMISSION_MANAGER.isStorageEditor(_getCaller())
       require(_permissionManager.hasRole(STORAGE_EDITOR_ROLE,_caller),"ONLY_STORAGE_EDITOR_ALLOWED");
       _;
    }
    
}