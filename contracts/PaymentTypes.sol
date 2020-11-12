// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";

contract PaymentTypes is PM {

    uint256  totalCategories;
    uint256 totalPaymentTypes;

    //paymentTypes categories
    // format mapping(index => name)
    mapping(uint26 => string) private  paymentTypesCategories;

    //payment type struct
    struct paymentTypeStruct {
        uint256 id;
        string  name;
        uint256 categoryId;
    }

    // paymentTypes 
    // format mapping(index => name)
    mapping(uint256 => paymentTypeStruct) private paymentTypesDB;

    /**
     * @dev add a new payment type category
     * @param categoryName category name in string
     */
     function addCategory(string memory categoryName) public  AdminsOnly() {

        uint256 catId  = totalCategories++;

        paymentTypesCategories[catId] = categoryName;
     } //end fun 


    /**
     * @dev delete a cetegory
     * @param catId category  id
     */
     function deleteCateory(uint256 catId) external  AdminsOnly() {
        delete  paymentTypesCategories[catId];
     } //end fun 

    
    /**
     * @dev add a new payment type category
     * @param categoryName category name in string
     */
     function updateCategory(uint256 catId) external  AdminsOnly() {
        paymentTypesCategories[catId] = categoryName;
     } //end fun 


    /**
     * addCategory
     */
    function addPaymentType(string memory name, uint256 categoryId ) public  AdminsOnly()  {

        //lets  check if categoryId exists 
        require(paymentTypesCategories[categoryId]  != "","Unknown Category");

    } //end 

} //end contractt