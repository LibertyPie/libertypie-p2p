/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "./Storage/StoreProxy.sol";
import "./Config.sol";

contract Base is PM, Config {

    //store Proxy
    IStorage public  _dataStore = StoreProxy(address(this)).getIStorage();
}