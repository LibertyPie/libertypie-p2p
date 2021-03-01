// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


import "./Assets.sol";
import "./Storage/StoreProxy.sol";
import "./Commons/OffersStructs.sol";
import "./Commons/PaymentMethodsStructs.sol";
import "./Base.sol";

contract Offers is Base {

    /*
     * @dev add a new offer  event 
     */
    event NewOffer(uint256 offerId);
    
    event DisableOffer(uint256 offerId);

    event UpdateOffer(uint256 offerId);

    // @dev get variables for the data store 
    bytes32 TOTAL_OFFERS_STORE_KEY = keccak256("Offers_total_offers");

    // offer types
    bytes32 OFFER_TYPE_BUY  =  toBytes32("buy");
    bytes32 OFFER_TYPE_SELL =  toBytes32("sell");

    bytes32 PRICING_MODE_MARKET = toBytes32("market");
    bytes32 PRICING_MODE_FIXED = toBytes32("fixed");

    Assets  _assets = Assets(address(this)); 

   bytes32 OFFERS_BY_USER_ADDRESS_INDEX_GROUP   = toBytes32("OFFERS_BY_USER_ADDRESS");

   bytes32 OFFERS_BY_ASSET_INDEX_GROUP          = toBytes32("OFFERS_BY_ASSET");

   bytes32 OFFERS_BY_COUNTRY_INDEX_GROUP        = toBytes32("OFFERS_BY_COUNTRY");

   bytes32 OFFERS_BY_CURRENCY_INDEX_GROUP       = toBytes32("OFFERS_BY_CURRENCY");

   bytes32 OFFERS_BY_OFFER_TYPE_INDEX_GROUP     = toBytes32("OFFERS_BY_OFFER_TYPE");

   bytes32 OFFERS_BY_PAYMENT_METHOD_INDEX_GROUP = toBytes32("OFFERS_BY_PAYMENT_METHOD");

        
   /**
   * @dev add a  new offer 
   *
   * @dev  OffersStructs.OfferInfo memory offerInfo 
      * @dev  asset the contract  address of the  asset  you wish to add the ad
      * @dev  offerType the offer type, either buy or sell
      * @dev  countryCode the country  where   ad is   targeted at
      * @dev  currencyCode 2 letter iso currency code 
      * @dev  paymentMethod enabled payment type for the offer
      * @dev  extraDataHash  extra data hash
      * @dev  extraDataStoreId Store , 1 for ipfs, 2 for sia skynet , 3....
      * @dev  isEnabled, if offer is enabled or not
      * @dev  expiry  offer expiry, 0 for non expiring offer, > 0 for expiring offer

   * @dev OffersStructs.PricingInfo memory pricingInfo
      * @dev  pricingMode the pricing mode for the offer
      * @dev  profitMargin if the pricingMode is market, then the amount in percentage added to the market price
      * @dev  fixedPrice if pricingMode is fixed, then the offer amount in usd

   * @dev OffersStructs.TradeInfo memory offerTradeInfo
      * @dev  minTradeAmountLimit uint256 minimum trade amount limit for the offer
      * @dev  maxTradeAmountLimit uint256 maximum trade  amount limit for the offer
      * @dev  hasSecurityDeposit bool if security deposit is enabled
      * @dev  securityDepositRate uint256 if security deposit is enabled, the amount in percentage
      * @dev  paymentWindow uint256 the time duration in milliseconds required to make a payment after a trade is opened
      * @dev  partnerMinimumTrades uint256 partner minimum required trades to be qualified to open trade to this offer
      * @dev  partnerMinimumReputation uint256 partner minimum reputation required to qualify for this offer
   */
   function newOffer(
      OffersStructs.OfferInfo memory _offerInfo,
      OffersStructs.PricingInfo memory _pricingInfo,
      OffersStructs.TradeInfo memory _offerTradeInfo
   ) external {

      //validate country
      require(_offerInfo.countryCode.length == 2, "XPIE:INVALID_COUNTRY_CODE");

      require(_offerInfo.currencyCode.length == 2, "XPIE:INVALID_CURRENCY_CODE");

      //check if asset is supported
      require(_assets.isAssetSupported(_offerInfo.asset),"XPIE:UNSUPPORTED_ASSET");
   
      require((_offerInfo.offerType == OFFER_TYPE_BUY || _offerInfo.offerType == OFFER_TYPE_SELL), "XPIE:INVALID_OFFER_TYPE");

      //save offer data 
      //lets get nextOfferId
      uint256 offerId = _dataStore.getNextOfferId();

      PaymentMethodsStructs.PaymentMethodItem memory paymentMethodData =  _dataStore.getPaymentMethodData(
         _offerInfo.paymentMethod
      );

      //validate payment method
      require(paymentMethodData.isEnabled == true, "XPIE:UNKNOWN_PAYMENT_METHOD");

      //validate the pricing mode
      require((_pricingInfo.pricingMode == PRICING_MODE_MARKET || _pricingInfo.pricingMode == PRICING_MODE_FIXED), "XPIE:UNKOWN_PRICING_MODE");

      //i security deposit is enabled, lets process it
      if(_offerTradeInfo.hasSecurityDeposit == true){
         
         require(_offerTradeInfo.securityDepositRate > 0, statusMsg("SECURITY_DEPOSIT_TOO_SMALL", toBytes32(0)));

          //min payment window
         bytes32 maxSecurityDeposit = getConfig("MAX_SECURITY_DEPOSIT");

         require(toBytes32(_offerTradeInfo.securityDepositRate) > maxSecurityDeposit, statusMsg("SECURITY_DEPOSIT_TOO_LARGE",maxSecurityDeposit));

      } //end if security deposit is enabled

      //min payment window
      bytes32 minPaymentWindow = getConfig("MIN_PAYMENT_WINDOW");

      //compare 
      require(toBytes32(_offerTradeInfo.paymentWindow) >= minPaymentWindow, statusMsg("PAYMENT_WINDOW_TOO_SMALL", minPaymentWindow));

      //if we have partner min reputation
      if(_offerTradeInfo.partnerMinimumReputation > 0){

         //lets check reputation
         bytes32 maxReputation = getConfig("MAX_REPUTATION");

         require(toBytes32(_offerTradeInfo.partnerMinimumReputation) <= maxReputation, statusMsg("PARTNER_REPUTATION_EXCEEDS_MAX", maxReputation));
      } //end if

      //lets now prepare for save 
      _dataStore.saveOfferData(
         offerId,
         OffersStructs.OfferItem({
            id:          offerId,
            owner:       msg.sender,
            offerInfo:   _offerInfo,
            pricingInfo: _pricingInfo,
            tradeInfo:   _offerTradeInfo
         })
      );


      //lets now save indexes 

      //add offer index for user address 
      _dataStore.setOfferIndex(OFFERS_BY_USER_ADDRESS_INDEX_GROUP, msg.sender, offerId);

      //add offer index for asset group
      _dataStore.setOfferIndex(OFFERS_BY_ASSET_INDEX_GROUP, _offerInfo.asset, offerId);

       //add offer index for country group
      _dataStore.setOfferIndex(OFFERS_BY_COUNTRY_INDEX_GROUP, _offerInfo.countryCode, offerId);

       //add offer index for currency group
      _dataStore.setOfferIndex(OFFERS_BY_CURRENCY_INDEX_GROUP, _offerInfo.currencyCode, offerId);

      //add offer index for payment method group
      _dataStore.setOfferIndex(OFFERS_BY_PAYMENT_METHOD_INDEX_GROUP, _offerInfo.paymentMethod, offerId);

      _dataStore.setOfferIndex(OFFERS_BY_PAYMENT_METHOD_INDEX_GROUP, _offerInfo.paymentMethod, offerId);

      _dataStore.setOfferIndex(OFFERS_BY_OFFER_TYPE_INDEX_GROUP, _offerInfo.offerType, offerId);
      
      emit NewOffer(offerId);
   } //end fun 


   /**
    * @dev get offer by id 
    * @param _id offer id
    */
   function getOffer(uint256 _id) public view returns (OffersStructs.OfferItem memory) {
      return _dataStore.getOfferData(_id);
   }


   /**
    * @dev get list of offers with filter included 
    *  
    */

}  //end contract 