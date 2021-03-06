// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PriceFeeds/PriceFeed.sol";
import "./Assets.sol";
import "./PermissionManager/PM.sol";

import "./PaymentMethods.sol";

import "./Base.sol";

contract Factory is  Base, PriceFeed, Assets, PaymentMethods  {
    
    constructor() {} //end fun 


} //end contract