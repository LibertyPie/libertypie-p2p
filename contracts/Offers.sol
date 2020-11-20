// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


import "./Assets.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Offers {

    /*
     * @dev add a new offer  event 
     */
    event _newOffer(uint256 offerId);

    Assets  _assets = Assets(address(this)); 

    //total ads defaults  to 0
    uint256 totalOffers;

    struct OfferStruct {
        address  asset;
        string   _type;
        address  owner;
        uint256  priceMargin;
        string   countryCode;
        uint256  paymentType;
        string   description;
        bool     enabled;
        uint256  expiry;
    }

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

    /**
     * @dev add a  new offer 
     * @param _assetAddress the contract  address of the  asset  you wish to add the ad
     * @param _offerType the offer type, either buy or sell
     * @param _priceMargin the profit margin in percentage to add to the asset price
     * @param countryCode the country  where   ad is   targeted at
     * @param paymentTypeId enabled payment type for the ad
     * @param description offer description  and instructions
     * @param expiry  offer expiry, 0 for non expiring offer, > 0 for expiring offer
     */
    function newOffer(
        address  _assetAddress,
        string  memory _offerType,
        uint256  _priceMargin,
        string   memory countryCode,
        uint256  paymentTypeId,
        string memory  description,
        uint256  expiry
    ) public {

        require(bytes(countryCode).length == 2, "XPIE:INVALID_COUNTRY_CODE");

        //check if asset is supported
        require(_assets.isAssetSupported(_assetAddress),"XPIE:UNSUPPORTED_ASSET");
    

        //check user  balance  for that asset,  if user balance  is 0, he cannot add an ad
        uint256 userBalance = IERC20(_assetAddress).balanceOf(msg.sender);

        require(userBalance > 0,"XPIE:INSUFFIENT_ASSET_BALANCE");

        //adIndex 
        uint256 _index  = totalOffers++;

        //lets  now inser  the  ad
        OffersData[_index]  = OfferStruct(
            _assetAddress, 
            _offerType,
            msg.sender, 
            _priceMargin,  
            countryCode, 
            paymentTypeId, 
            true
        );

        //add ad  index for asset indexes 
        OffersByAssetAddress[_assetAddress].push(_index);

        //add  ad to user  ads  collections 
         OffersByUserAddress[msg.sender].push(_index);

        //add  index based on country 
        OffersByCountryCode[countryCode].push(_index);

        //add index  based on payment Type 
        OffersByPaymentType[paymentTypeId].push(_index);

        OffersByPaymentType[paymentTypeId].push(_index);

        //emit even with offer id
        emit  _newOffer(_index);
    } //end fun 

}  //end contract 