/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

/**
 * @dev payment method struct Implementation
 */
contract PaymentMethodsStructs {
    

   struct PaymentMethodItem {
      uint256 id; 
      string  name;
      uint256 categoryId;
      uint256 minPaymentWindow;
      uint256 maxPaymentWindow;
      string[] countries;
      string[] continents;
      bool isEnabled;
   }


   /**
    * category Struct
    */
    struct CategoryItem {
        uint256 id; 
        string name;
        bool isEnabled;
    }
    
}