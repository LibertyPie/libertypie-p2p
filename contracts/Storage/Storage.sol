/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "../PermissionManager/PM.sol";
import "./BasicStore.sol";
import "./DappStore.sol";
import "./StoreEditor.sol";

contract Storage is BasicStore, ComplexStore, StoreEditor, DappStore {

    /**
     * Note this accepts the storage admin address, which is the 
     * contracts which will be updating and storing in this contract
     */
    constructor(address storageAdmin) public {
        //lets add pm role
        PM.grantRole(STORAGE_ADMIN_ROLE,address);
    }

}   