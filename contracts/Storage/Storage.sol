/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";
import "./BasicStore.sol";
import "./OffersStore.sol";
//import "./StoreEditor.sol";
import "./PaymentMethodsStore.sol";
import "./AssetsStore.sol";

contract Storage is 
        PM, 
        //StoreEditor, 
        BasicStore, 
        OffersStore, 
        PaymentMethodsStore,
        AssetsStore
{

    /**
     * Note this accepts the storage admin address, which is the 
     * contracts which will be updating and storing in this contract
     *
    constructor(address _dappAddress) public {
        //lets add pm role,
        // this should be the address of the contract which will be
        // allowed to write to storage
        grantRole(STORAGE_EDITOR_ROLE,_dappAddress);
    }*/
        
}   