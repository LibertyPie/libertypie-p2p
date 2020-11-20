// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";
import  "./PaymentTypesCore.sol";
  
contract PaymentTypes is PM {

   //add category event
   event addPaymentTypeCategoryEvent(string name, uint256 id);

   // Payment types core contract  instance
   PaymentTypesCore public PAYMENT_TYPES_CORE;

   //payment type struct
   struct PaymentTypeStruct {
      uint256 id;
      string  name;
      uint256 categoryId;
   }
    
   /**
    * @dev  set the  payment types  db contract address internally
    */
    function _setPaymentTypesCoreAddress(address _newAddress) internal {
        PAYMENT_TYPES_CORE = PaymentTypesCore(_newAddress);
    }

   /**
    * @dev set the  payment types  db contract address externally
    */
    function setPaymentTypesCoreAddress(address _newAddress) external onlySuperAdmins () {
       _setPaymentTypesCoreAddress(_newAddress);
    }

    /**
     * @dev  get all payment types categories  
     */
   function  getPaymentTypesCategories() external view returns (string[] memory){
      return PAYMENT_TYPES_CORE.getAllCategories();
   }
   
    
    /**
     * @dev get payment  type  by id
     * this helps us use  an external storage for the payment types
     * @param id payment  type id
     * return (string memory, uint256, string memory)
     *  paymentTypeName, categoryId
     */
   function  getPaymentTypeById(uint256 id) external view returns(PaymentTypeStruct memory){
      return PAYMENT_TYPES_CORE.getPaymentTypeById(id);
   }

   /**
    * @dev get payment types  by cat  id
    * @param catId the category id
    * @return (string[]) 
    */
   function getPaymentTypesByCatId(uint256 catId) external view returns(PaymentTypeStruct[] memory ){
      return PAYMENT_TYPES_CORE.getPaymentTypesByCatId(catId);
   }

   /**
    * @dev get all payment  types 
    *  return (uint256[], string[], uint256[])
    *  paymentTypeId  Array, paymentTypeName Array, categoryId Array
    */
   function getAllPaymentTypes() external view returns(PaymentTypeStruct[] memory) {
      return PAYMENT_TYPES_CORE.getAllPaymentTypes(); 
   } // end 


   /**
    * @dev add Payment Type Category
    * @param name  payment type category name string
    * @return uint256
    */
    function  addPaymentTypeCategory(string calldata name) external returns(uint256){
       uint256 id = PAYMENT_TYPES_CORE.addCategory(name); 
       emit addPaymentTypeCategoryEvent(name,id);
       return id;
    }

    
   /**
   * @dev check if payment type is valid
   * @param id payment  type index 
   */
   //function isValidPaymentType(uint256 id) public view return (bool) {
      
   //}

}