/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

contract PaymentTypes is PM {

   uint256  totalCategories;
   uint256 totalPaymentTypes;

   struct PaymentTypeStruct {
      uint256 id;
      string  name;
      uint256 categoryId;
   }

    constructor() public  {

      //default categories 
      _addCategory("Bank Transfers");
      _addCategory("Online Wallets");
      _addCategory("Cash Payments");
      _addCategory("Credit or Debit Cards");
      _addCategory("Gift Cards");
      _addCategory("Digital Currencies");
      _addCategory("Goods  & Services");
      _addCategory("Others");

    } //end function


    //paymentTypes categories
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => string) private  PaymentTypesCategories;


    // paymentTypes 
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => PaymentTypeStruct) private PaymentTypesData;

   /**
   * @dev add a new payment type category
   * @param name category name in string
   * @return uint256 new category  id
   */
   function addPaymentTypeCategory(string calldata name) external  onlyAdmins() returns(uint256) {
      return _addCategory(name);
   } //end fun 


   /**
   * @dev add a new payment type category
   * @param name category name in string
   * @return uint256 new  category id
   */
   function _addCategory(string memory name) private returns(uint256) {

      //get id
      uint256 id  = totalCategories++;

      PaymentTypesCategories[id] = name;

      return id;
   } //end fun 


   /**
   * @dev delete a cetegory
   * @param categoryId category  id
   */
   function deletePaymentTypeCategory(uint256 categoryId) external onlyAdmins() {
      delete  PaymentTypesCategories[categoryId];
   } //end fun 

    
   /**
   * @dev add a new payment type category
   * @param categoryId category id
   * @param newCategoryName  new category name to change
   */
   function updatePaymentTypeCategory(uint256 categoryId,  string calldata newCategoryName) external  onlyAdmins() {
      PaymentTypesCategories[categoryId] = newCategoryName;
   } //end fun 


   /**
   * @dev add a new payment  type
   * @param name payment  type name
   * @param categoryId category id for the new payment  type
   * @return uint256
   */
   function addPaymentType(string memory name, uint256 categoryId ) external  onlyAdmins() returns(uint256) {

      //lets  check if categoryId exists 
      require(bytes(PaymentTypesCategories[categoryId]).length > 0,"XPIE:UNKNOWN_CATEGORY");

      //avoid totalPaymentTypes++
      //counting starts from 1, so index 0 wont exist
      uint256 id  = totalPaymentTypes += 1;

      PaymentTypesData[id] = PaymentTypeStruct(id, name, categoryId);

      return id;
   } //end 

   /**
   * @dev remove  a payment type 
   * @param id  the payment type id
   */
   function removePaymentType(uint256 id) external  onlyAdmins() {
      delete PaymentTypesData[id];
   }


   /**
   *  @dev update  payment type info
   *  @param currentId old paymentType id
   *  @param newName the new name of the paymentType
   *  @param  newCategoryId the new category id of the payment type
   */
   function updatePaymentType(uint256 currentId, string calldata newName, uint256 newCategoryId) external  onlyAdmins()  {
      
      //lets check if 
      require(currentId  <= totalPaymentTypes,"XPIE:UNKNOWN_PAYMENT_TYPE");

      PaymentTypesData[currentId] = PaymentTypeStruct(currentId, newName, newCategoryId);

   } //end fun


   /**
   *  @dev get all payment types categories 
   *  @return  (string[] memory) CategoryNames Array with category id as array index
   */
   function  getPaymentTypesCategories() public view returns (string[] memory ){
      
      string[] memory  categoriesArray = new string[] (totalCategories);
      
      //mapping index starts with 1, not  0
      for(uint256 i = 0; i < totalCategories; i++ ){
         categoriesArray[i] = PaymentTypesCategories[i];
      }

      return categoriesArray;
   } //end fun 

   /**
   * @dev get category by  id
   * @param id category id
   */
   function getCategoryById(uint256 id) external view returns (string  memory) {
      return PaymentTypesCategories[id];
   } //end fun 


   /* 
   * @dev get payment types using it category id
   * @param catId uint256 category id 
   * @return (string[]) paymentTypesArray
   */
   function getPaymentTypesByCatId(uint256 catId) external view returns( PaymentTypeStruct[] memory ) {

      require(bytes(PaymentTypesCategories[catId]).length > 0, "XPIE:CATEGORY_NOT_FOUND");

      //lets fetch the  payment types ids
      PaymentTypeStruct[] memory paymentTypesArray   = new PaymentTypeStruct[] (totalPaymentTypes);

      for(uint256  i = 1; i < totalPaymentTypes; i++){
         if(PaymentTypesData[i].categoryId == catId){
            paymentTypesArray[i] = PaymentTypesData[i];
         }
      }

      return paymentTypesArray;
   }  //end fun


   /**
   * @dev getPaymentTypeById
   * @param id paymentType  id
   * return ( string, uint256) paymentType name, cetegoryId)
   */
   function  getPaymentTypeById(uint256 id) external  view returns(string memory, uint256) {
      return (PaymentTypesData[id].name, PaymentTypesData[id].categoryId);
   } //end fun 
 
 
   /**
   * @dev get all payment types 
   */
   function getPaymentTypes() public view returns( PaymentTypeStruct[] memory  ) {

      PaymentTypeStruct[]  memory  paymentTypesDataArray = new PaymentTypeStruct[] (totalPaymentTypes);

      for(uint256 i = 0; i < totalPaymentTypes; i++ ){
         paymentTypesDataArray[i]    = PaymentTypesData[i];
      }

      return paymentTypesDataArray;
   }

   /**
    * @dev Fetch payment types and categories in a single query
    */
   function getPaymentTypesAndCats() external view returns (string[] memory, PaymentTypeStruct[] memory) {
      return (getPaymentTypesCategories(),getPaymentTypes());
   }//end 

}//end contract