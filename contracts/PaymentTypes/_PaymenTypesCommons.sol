/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

//import "../PermissionManager/PM.sol";

 interface _PaymenTypesCommons {

   //payment type struct
   struct PaymentTypeStruct {
      uint256 id;
      string  name;
      uint256 categoryId;
   }

}