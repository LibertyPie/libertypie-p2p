/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../../Commons/PaymentMethodsStructs.sol";

interface IPaymentMethodsStore {

    function getNextPaymentMethodId() external returns(uint256);
    function getNextPaymentMethodCategoryId() external returns(uint256);
    function savePaymentMethodsCategoryData(uint256 _id, PaymentMethodsStructs.CategoryItem memory _data ) external;
    function savePaymentMethodData(uint256 _id,PaymentMethodsStructs.PaymentMethodItem memory _data ) external;
    function deletePaymentMethodsCategoryData(uint256 _id) external;
    function deletePaymentMethodData(uint256 _id) external;
    function getTotalPaymentMethodsCategories() external view  returns (uint256);
    function getTotalPaymentMethods() external view  returns (uint256);
    function getPaymentMethodsCategoryData(uint256 _id) external view returns (PaymentMethodsStructs.CategoryItem memory);
    function getPaymentMethodData(uint256 _id) external view returns (PaymentMethodsStructs.PaymentMethodItem memory);

}