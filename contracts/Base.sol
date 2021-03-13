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

contract Base2 is Config {

  /**
   * @dev getStoreProxy
   */
    function getDataStore() public view returns(Istorage) {
        return StoreProxy(address(this)).getIStorage();
    }

}