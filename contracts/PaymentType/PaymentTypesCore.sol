// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

contract PaymentTypesCore is PM {

    uint256  totalCategories;
    uint256 totalPaymentTypes;


    constructor() public  {

      //default categories 
      addCategory("Bank Transfers");
      addCategory("Online Wallets");
      addCategory("Gift Cards");
      addCategory("Goods  & Services");

    } //end fun

    //paymentTypes categories
    // format mapping(index => name)
    mapping(uint256 => string) private  PaymentTypesCategories;

    //payment type struct
    struct PaymentTypeStruct {
        uint256 id;
        string  name;
        uint256 categoryId;
    }

    // paymentTypes 
    // format mapping(index => name)
    mapping(uint256 => PaymentTypeStruct) private PaymentTypesDB;

    /**
     * @dev add a new payment type category
     * @param categoryName category name in string
     */
     function addCategory(string memory categoryName) public  onlyAdmins() returns(uint256) {

        uint256 catId  = totalCategories++;

        PaymentTypesCategories[catId] = categoryName;

        return catId;
     } //end fun 


    /**
     * @dev delete a cetegory
     * @param catId category  id
     */
     function deleteCateory(uint256 catId) external onlyAdmins() {
        delete  PaymentTypesCategories[catId];
     } //end fun 

    
    /**
     * @dev add a new payment type category
     * @param catId category id
     * @param newCategoryName  new category name to change
     */
     function updateCategory(uint256 catId,  string memory newCategoryName) external  onlyAdmins() {
        PaymentTypesCategories[catId] = newCategoryName;
     } //end fun 


    /**
     * @dev add a new payment  type
     * @param name payment  type name
     * @param categoryId category id for the new payment  type
     * @return uint256
     */
    function addPaymentType(string memory name, uint256 categoryId ) public  onlyAdmins() returns(uint256) {

      //lets  check if categoryId exists 
      require(bytes(PaymentTypesCategories[categoryId]).length > 0,"Unknown Category");

      uint256 id  = totalPaymentTypes++;

      PaymentTypesDB[id] = PaymentTypeStruct(id, name, categoryId);

      return id;
    } //end 


    /**
     * @dev remove  a payment type 
     * @param id  the payment type id
     */
     function removePaymentType(uint256 id) external  onlyAdmins() {
        delete PaymentTypesDB[id];
     }


      /**
       *  @dev update  payment type info
       *  @param currentId old paymentType id
       *  @param newName the new name of the paymentType
       *  @param  newCategoryId the new category id of the payment type
       */
      function updatePaymentType(uint256 currentId, string memory newName, uint256 newCategoryId) external  onlyAdmins()  {
         
         //lets check if 
         require(PaymentTypesDB[currentId].id == 0,"Unknown Payment Type");

          PaymentTypesDB[currentId] = PaymentTypeStruct(currentId, newName, newCategoryId);

      } //end fun

      /**
       * @dev getPaymentTypeById
       * @param id paymentType  id
       * return ( string, uint256, string) paymentType name, cetegoryId, categoryId
       */
       function  getPaymentTypeById(uint256 id) external  view returns(string memory, uint256, string memory) {
          return (PaymentTypesDB[id].name, PaymentTypesDB[id].categoryId, PaymentTypesCategories[PaymentTypesDB[id].categoryId]);
       } //end fun 


} //end contractt