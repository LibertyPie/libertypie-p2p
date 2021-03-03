// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PriceFeeds/PriceFeed.sol";
import "./Assets.sol";
import  "./PermissionManager/PermissionManager.sol";
import "./PermissionManager/PM.sol";

import "./Storage/StoreEditor.sol";

import "./PaymentMethods.sol";
import "./Utils.sol";

contract Factory is Utils, Assets,  PaymentMethods, PriceFeed, StoreEditor {
    
    constructor() {

        //initiate Permission Manager contracts
        PM._setPermissionManager(address(new PermissionManager(msg.sender)));

        // PaymentTypes  Core contract address
        //PaymentTypes._setPaymentTypesCoreAddress(address(new PaymentTypesCore()));

        //lets set store editor address
        //lets add pm role,
        // this should be the address of the contract which will be
        // allowed to write to storage
        grantRole(STORAGE_EDITOR_ROLE,address(this));

    } //end fun 


} //end contract