/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../../Commons/PaymentMethodsStructImpl.sol";

interface IPaymentMethodsStore {

    function getNextPaymentMethodId() external returns(uint256);
    function getNextCategoryId() external returns(uint256);
    function savePaymentMethodsCategoryData(uint256 _id,PaymentMethodsStructImpl.CategoryStruct memory _data) external;
    function savePaymentMethodData(uint256 _id,PaymentMethodsStructImpl.PaymentMethodStruct memory _data) external;
    function deletePaymentMethodsCategoryData(uint256 _id) external;
    function deletePaymentMethodData(uint256 _id) external;
    function getTotalPaymentMethods() external view  returns (uint256);
    function getTotalPaymentMethods() external view  returns (uint256);
    function getPaymentMethodsCategory(uint256 _id) external view returns (CategoryStruct);

}