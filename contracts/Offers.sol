// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


import "./Assets.sol";
import "./Storage/StoreProxy.sol";
import "./Commons/OffersStructs.sol";
import "./Commons/PaymentMethodsStructs.sol";

contract Offers is Context {

    /*
     * @dev add a new offer  event 
     */
    event NewOffer(uint256 offerId);
    
    event DisableOffer(uint256 offerId);

    event UpdateOffer(uint256 offerId);

    // @dev get variables for the data store 
    bytes32 TOTAL_OFFERS_STORE_KEY = keccak256("Offers_total_offers");

    // offer types
    bytes32 OFFER_TYPE_BUY  =  keccak256("buy");
    bytes32 OFFER_TYPE_SELL = keccak256("sell");

    Assets  _assets = Assets(address(this)); 

   //get storage implementations
    IStorage dataStore = StoreProxy(address(this)).getIStorage();

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
   *
   *    @dev  OffersStructImpl.OfferInfo memory offerInfo 
      * @dev  asset the contract  address of the  asset  you wish to add the ad
      * @dev  offerType the offer type, either buy or sell
      * @dev  countryCode the country  where   ad is   targeted at
      * @dev  currencyCode 2 letter iso currency code 
      * @dev  paymentMethodId enabled payment type for the offer
      * @dev  extraDataHash  extra data hash
      * @dev  extraDataStoreId Store , 1 for ipfs, 2 for sia skynet , 3....
      * @dev  isEnabled, if offer is enabled or not
      * @dev  expiry  offer expiry, 0 for non expiring offer, > 0 for expiring offer

   * @dev OffersStructImpl.PricingInfo memory pricingInfo
      * @dev  pricingMode the pricing mode for the offer
      * @dev  profitMargin if the pricingMode is market, then the amount in percentage added to the market price
      * @dev  fixedPrice if pricingMode is fixed, then the offer amount in usd

   * @dev OffersStructImpl.TradeInfo memory offerTradeInfo
      * @dev  minTradeAmountLimit uint256 minimum trade amount limit for the offer
      * @dev  maxTradeAmountLimit uint256 maximum trade  amount limit for the offer
      * @dev  hasSecurityDeposit bool if security deposit is enabled
      * @dev  securityDepositRate uint256 if security deposit is enabled, the amount in percentage
      * @dev  paymentWindow uint256 the time duration in milliseconds required to make a payment after a trade is opened
      * @dev  partnerMinimumTrades uint256 partner minimum required trades to be qualified to open trade to this offer
      * @dev  partnerMinimumReputation uint256 partner minimum reputation required to qualify for this offer
   */
   function newOffer(
      OffersStructImpl.OfferInfo memory offerInfo,
      OffersStructImpl.PricingInfo memory pricingInfo,
      OffersStructImpl.TradeInfo memory offerTradeInfo
   ) external {

      //validate country
      require(offerInfo.countryCode.length == 2, "XPIE:INVALID_COUNTRY_CODE");

      require(offerInfo.currencyCode.length == 2, "XPIE:INVALID_CURRENCY_CODE");

      //check if asset is supported
      require(_assets.isAssetSupported(offerInfo.asset),"XPIE:UNSUPPORTED_ASSET");
   
      require((offerInfo.offerType == OFFER_TYPE_BUY || offerInfo.offerType == OFFER_TYPE_SELL), "XPIE:INVALID_OFFER_TYPE");

      //save offer data 
      //lets get nextOfferId
      uint256 offerId = dataStore.getNextOfferId();

      PaymentMethodsStructs.PaymentMethodItem memory paymentMethodData =  dataStore.getPaymentMethodData(
         OffersStructImpl.OfferInfo.paymentMethodId
      );

      //validate payment method
      require(paymentMethodData.isEnabled == true, "XPIE:UNKNOWN_PAYMENT_METHOD");



   } //end fun 


}  //end contract 