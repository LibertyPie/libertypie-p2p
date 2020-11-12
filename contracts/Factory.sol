// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PriceFeed.sol";
import "./Assets.sol";
import  "./PermissionManager/PermissionManager.sol";
import "./PermissionManager/PM.sol";

contract Factory is  Assets, PriceFeed, PM {

    constructor() public {

        //initiate Permission Manager
        PM._setAddress(address(new PermissionManager()));

    } //end fun 

}