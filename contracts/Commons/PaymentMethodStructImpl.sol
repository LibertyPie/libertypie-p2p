/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

/**
 * @dev payment method struct Implementation
 */
contract PaymentMethodStructImpl {
    

   struct PaymentMethodStruct {
      uint256 id; 
      string  name;
      uint256 categoryId;

      uint256 minPaymentWindow;
      uint256 maxPaymentWindow;
      string[] countries;
      bool isEnabled;
   }


   /**
    * category Struct
    */
    struct CategoryStruct {
        uint256 id; 
        string name;
        string[] countries;
        bool isEnabled;
    }
    
}