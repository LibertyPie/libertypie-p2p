// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PriceFeeds/PriceFeed.sol";
import "./Assets.sol";
//mport "./PermissionManager/PM.sol";

import "./PaymentMethods.sol";

//import "./Config.sol";

//import "./Storage/DataStore.sol";


contract Factory is PaymentMethods, PriceFeed, Assets {
    
    constructor(
        address _permissionManagerContract,
        address _storageContract
    ) {

        //lets initialize pm 
        initializePermissionManager(_permissionManagerContract);

        //initialize data store 
        initializeDataStore(_storageContract);

    } //end fun 


} //end contract