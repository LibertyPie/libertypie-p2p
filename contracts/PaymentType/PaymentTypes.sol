// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";


interface  IPaymentTypesCore  {
   function  getAllPaymentTypes(uint256 id) external returns(uint256, string memory, uint256, string memory); 
   function  getPaymentTypeById(uint256 id) external returns(string memory, uint256, string memory);
}

contract PaymentTypes is PM {

    IPaymentTypesCore _paymentTypesCore;
    

    function _setPaymentTypesContract(address _newAddress) internal {
        _paymentTypes = IPaymentTypes(_newAddress);
    }

    function setPaymentTypesAddress(address _newAddress) external onlySuperAdmins () {
       _setPaymentTypesContract(_newAddress);
    }

    
    /**
     * @dev get payment  type  by id
     * this helps us use  an external storage for the payment types
     * @param id payment  type id
     * return (string memory, uint256, string memory)
     *  paymentTypeName, categoryId, CategoryName
     */
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256, string memory){
      return (string memory name, uint256 categoryId, string memory categoryName) =  _paymentTypesCore.getPaymentTypeById(id);
   }

   /**
    * @dev get all payment  types 
    *  return (uint256[], string[], uint256[], string[])
    *  paymentTypeId, paymentTypeName, categoryId, CategoryName
    */
   function getAllPaymentTypes() external view  returns(uint256[], string[], uint256[], string[]) {

      
   } // end 


}