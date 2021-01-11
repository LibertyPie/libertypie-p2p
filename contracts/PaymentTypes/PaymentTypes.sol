/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";
import "./_PaymenTypesCommons.sol";

interface IPaymentTypes is _PaymenTypesCommons {
   function getAllCategories() external view returns (string[] memory );
   function getCategoryById(uint256 id) external view returns (string  memory);
   function getPaymentTypesByCatId(uint256 catId) external view returns( PaymentTypeStruct[] memory );
   function  getPaymentTypeById(uint256 id) external  view returns(string memory, uint256);
   function getAllPaymentTypes() external view returns( PaymentTypeStruct[] memory  );
  // function addCategory(string calldata name) external returns(uint256);
}
  
contract PaymentTypes is PM, _PaymenTypesCommons {

   //add category event
   event addPaymentTypeCategoryEvent(string name, uint256 id);

   // Payment types core contract  instance
   IPaymentTypes public PAYMENT_TYPES_CORE;

  /**
    * @dev  set the  payment types  db contract address internally
    * @param  _newAddress set or change the contract address for the paymentTypesCore
    */
   function _setPaymentTypesCoreAddress(address _newAddress) internal {
      PAYMENT_TYPES_CORE = IPaymentTypes(_newAddress);
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
   function  getPaymentTypesCategories() public view returns (string[] memory){
      return PAYMENT_TYPES_CORE.getAllCategories();
   }
   
   /**
    * getAllPaymentTypes 
    * @return (uint256) 
    */
   function getAllPaymentTypes() public view returns (PaymentTypeStruct[] memory) {
      //first of all lets get the cats here 
       return PAYMENT_TYPES_CORE.getAllPaymentTypes();
   }

   /**
    * getAllPaymentTypesAndCats
    */
    function getAllPaymentTypesAndCats() external view returns (string[] memory, PaymentTypeStruct[] memory) {
       return (getPaymentTypesCategories(),getAllPaymentTypes());
    }//end 

    
   /**
   * @dev get payment  type  by id
   * this helps us use  an external storage for the payment types
   * @param id payment  type id
   * return (string memory, uint256, string memory)
   *  paymentTypeName, categoryId
   */
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256){
      return PAYMENT_TYPES_CORE.getPaymentTypeById(id);
   }

   /**
    * @dev get payment types  by cat  id
    * @param catId the category id
    * @return (string[]) 
    */
   function getPaymentTypesByCatId(uint256 catId) external view returns( PaymentTypeStruct[] memory ){
      return PAYMENT_TYPES_CORE.getPaymentTypesByCatId(catId);
   }

}