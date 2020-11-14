// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";


interface  IPaymentTypesCore  {
   function  getAllCategories() external view returns (string[] memory);
   function getCategoryById(uint256 id) external view returns (string memory);
   function getAllPaymentTypes() external view returns(uint256[] memory, string[] memory, uint256[] memory);
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256);
}

contract PaymentTypes is PM {
   
   // Payment types core contract  instance
    IPaymentTypesCore _paymentTypesCore;
    
   /**
    * @dev  set the  payment types  db contract address internally
    */
    function _setPaymentTypesContract(address _newAddress) internal {
        _paymentTypesCore = IPaymentTypesCore(_newAddress);
    }

   /**
    * @dev set the  payment types  db contract address externally
    */
    function setPaymentTypesAddress(address _newAddress) external onlySuperAdmins () {
       _setPaymentTypesContract(_newAddress);
    }

    /**
     * @dev  get all payment types categories  
     */
   function  getAllCategories() external view returns (string[] memory){
      return _paymentTypesCore.getAllCategories();
   }

    
    /**
     * @dev get payment  type  by id
     * this helps us use  an external storage for the payment types
     * @param id payment  type id
     * return (string memory, uint256, string memory)
     *  paymentTypeName, categoryId
     */
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256){
      return _paymentTypesCore.getPaymentTypeById(id);
   }

   /**
    * @dev get all payment  types 
    *  return (uint256[], string[], uint256[])
    *  paymentTypeId  Array, paymentTypeName Array, categoryId Array
    */
   function getAllPaymentTypes() external view returns(uint256[] memory, string[] memory, uint256[] memory) {
      return _paymentTypesCore.getAllPaymentTypes(); 
   } // end 


}