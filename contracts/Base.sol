/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "./Storage/DataStore.sol";
import "./Config.sol";
import "./Storage/Interfaces/IStorage.sol";

contract Base is  Config, DataStore {

  IStorage _dataStore;

  constructor(){

      //Set data store
      _dataStore = getStore();

      setConfigDataStore(_dataStore);
  }

  /**
   * @dev getStoreProxy
   */
    function getDataStore() public view returns(IStorage) {
        return _dataStore;
    }

}