/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/PaymentMethodsStructs.sol";


contract PaymentMethodsStore is StoreEditor  {

    uint256  totalPaymentMethodsCategories;
    uint256  totalPaymentMethods;

    //paymentTypes categories
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => PaymentMethodsStructs.CategoryItem) private  PaymentMethodsCategories;


    // paymentTypes 
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => PaymentMethodsStructs.PaymentMethodItem) private PaymentMethodsData;


     /**
     * @dev generate or get next catId
     */
    function getNextPaymentMethodCategoryId() external onlyStoreEditor returns(uint256) {
        return (++totalPaymentMethodsCategories);
    }

    /**
     * @dev get total payment methods
     */
     function getTotalPaymentMethods() public view  returns (uint256) {
        return totalPaymentMethods;
     }

       /**
     * @dev get total categories
     */
     function getTotalPaymentMethodsCategories() public view  returns (uint256) {
        return totalPaymentMethodsCategories;
     }

    /**
     * getNextPaymentMethodId
     */
    function getNextPaymentMethodId() external onlyStoreEditor returns(uint256) {
        return (++totalPaymentMethods);
    }

    /**
     * addPaymentMethod
     */
    function savePaymentMethodData(uint256 _id,PaymentMethodsStructs.PaymentMethodItem memory _data ) external onlyStoreEditor {
        PaymentMethodsData[_id] = _data;
    }


    /**
     * @dev save category data
     * @param _id category id
     */
    function savePaymentMethodsCategoryData(uint256 _id, PaymentMethodsStructs.CategoryItem memory _data ) external onlyStoreEditor { 
        PaymentMethodsCategories[_id] = _data;
    }

    /**
     * deleteCategoryData
     * @param _id category id
     */
    function deletePaymentMethodsCategoryData(uint256 _id) external  onlyStoreEditor {
        delete PaymentMethodsCategories[_id];
    }

    /**
     * deleteCategoryData
     * @param _id category id
     */
    function deletePaymentMethodData(uint256 _id) external  onlyStoreEditor {
        delete PaymentMethodsData[_id];
    }
    

    /**
     * get payment method category
     * @param _id payment method category id
     */
     function getPaymentMethodsCategoryData(uint256 _id) external view returns (PaymentMethodsStructs.CategoryItem memory) {
        return PaymentMethodsCategories[_id];
     } //end fun 

    /**
     * @dev get payment method data
     * @param _id payment method id
     */
     function getPaymentMethodData(uint256 _id) external view returns (PaymentMethodsStructs.PaymentMethodItem memory) {
        return PaymentMethodsData[_id];
     } //end fun 
}