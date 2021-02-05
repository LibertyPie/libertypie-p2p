/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
contract IStorage {
    
    //offers mapping
    struct OfferStruct {
        address  asset;
        string   _type;
        address  owner;
        string   pricingMode;
        uint256  profitMargin;
        uint256  fixedPrice;
        string   countryCode;
        uint256  paymentType;
        string   extraDataHash;
        int      dataStoreId;
        bool     isEnabled;
        uint256  expiry;
    }

}