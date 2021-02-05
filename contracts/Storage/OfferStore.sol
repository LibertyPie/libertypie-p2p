/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
//import "./IStorage.sol";

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

contract OfferStore {

    //offer index mapping
    //offers data
    //format is mapping(adIndex => adStruct)
    mapping(uint256 => OfferStruct) private OffersData;

    //user ad index 
    //save  into user map
    //format  mapping( msg.sender =>  _index)
    mapping(address => uint256[]) private OffersByUserAddress;

    // assets  Ads  indexes 
    //format  mapping( assetAddress =>  _index)
    mapping(address => uint256[])  private OffersByAssetAddress;

    // offers indexes based  on country
     //format  mapping(countryCode =>  _index)
    mapping(string => uint256[]) private  OffersByCountryCode;

    //offers indexes based on offer type
    mapping(string => uint256[]) private  OffersByType;

    //offers indexes based on paymentTypeId 
    mapping(uint256 => uint256[]) private  OffersByPaymentType;

    
}