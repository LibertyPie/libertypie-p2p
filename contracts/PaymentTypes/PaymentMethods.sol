/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

import "../Storage/StoreProxy.sol";
import "../Commons/PaymentMethodStructImpl.sol";


contract PaymentMethods is PM {

    event AddPaymentMethodCategory(uint256 catId);


    IStorage dataStore = StoreProxy(address(this)).getIStorage();

    /**
   * @dev add a new payment type category
   * @param name category name in string
   * @param countries supported countries, leave empty to target all countries
   * @return uint256 new category  id
   */
   function addPaymentMethodCategory(
       string calldata name,
       string[] memory countries,
       bool isEnabled
    ) external  onlyAdmin() returns(uint256) {
     
        uint256 catId = dataStore.getNextCategoryId();

        PaymentMethodStructImpl.CategoryStruct memory _dataToSave = PaymentMethodStructImpl.CategoryStruct(
            catId,
            name,
            countries,
            isEnabled
        );

        dataStore.saveCategoryData(
            catId,
            _dataToSave
        );

        AddPaymentMethodCategory(catId);

        return catId;
   } //end fun 



}//end contract