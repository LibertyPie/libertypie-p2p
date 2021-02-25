/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/PaymentMethodStructImpl.sol";

contract PaymentMethodStore is StoreEditor, PaymentMethodStructImpl  {

    uint256  totalCategories;
    uint256  totalPaymentMethods;

    //paymentTypes categories
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => CategoryStruct) private  PaymentTypesCategories;


    // paymentTypes 
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => PaymentMethodStruct) private PaymentTypesData;


     /**
     * @dev generate or get next catId
     */
    function getNextCategoryId() external onlyStoreEditor returns(uint256) {
        return (totalCategories += 1);
    }

    /**
     * getNextPaymentMethodId
     */
    function getNextPaymentMethodId() external onlyStoreEditor returns(uint256) {
        return (totalPaymentMethods += 1);
    }

    /**
     * addPaymentMethod
     */
    function savePaymentMethodData(
        uint256 _id,
        PaymentMethodStructImpl.PaymentMethodStruct memory _data
    ) external onlyStoreEditor {
        PaymentTypesData[_id] = _data;
    }


    /**
     * @dev save category data
     */
    function saveCategoryData(
        uint256 _id,
        PaymentMethodStructImpl.CategoryStruct memory _data
    ) external onlyStoreEditor { 
        PaymentTypesCategories[_id] = _data;
    }

}