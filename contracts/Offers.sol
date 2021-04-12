/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;


import "./Assets.sol";
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

   struct OfferListFilter {
      address  asset;
      bytes32  offerType;
      bytes32  pricingMode;
      bytes32  countryCode;
      address  owner;
      uint256  paymentMethod;
      uint256  minRating;
   }

   int public OFFER_SORT_ASC =  0;
   int public  OFFER_SORT_DESC = 1;

   struct OfferSort {
      bytes32 orderBy;
      int     orderMode;
   }
    
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
      uint256 offerId = getDataStore().getNextOfferId();

      PaymentMethodsStructs.PaymentMethodItem memory paymentMethodData =  getDataStore().getPaymentMethodData(
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
      getDataStore().saveOfferData(
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
      getDataStore().setOfferIndex(OFFERS_BY_USER_ADDRESS_INDEX_GROUP, toBytes32(msg.sender), offerId);

      //add offer index for asset group
      getDataStore().setOfferIndex(OFFERS_BY_ASSET_INDEX_GROUP, toBytes32(_offerInfo.asset), offerId);

       //add offer index for country group
      getDataStore().setOfferIndex(OFFERS_BY_COUNTRY_INDEX_GROUP, _offerInfo.countryCode, offerId);

       //add offer index for currency group
      getDataStore().setOfferIndex(OFFERS_BY_CURRENCY_INDEX_GROUP, _offerInfo.currencyCode, offerId);

      //add offer index for payment method group
      getDataStore().setOfferIndex(OFFERS_BY_PAYMENT_METHOD_INDEX_GROUP, toBytes32(_offerInfo.paymentMethod), offerId);


      getDataStore().setOfferIndex(OFFERS_BY_OFFER_TYPE_INDEX_GROUP, _offerInfo.offerType, offerId);
      
      emit NewOffer(offerId);
   } //end fun 


   /**
    * @dev get offer by id 
    * @param _id offer id
    */
   function getOfferById(uint256 _id) public view returns (OffersStructs.OfferItem memory) {
      return getDataStore().getOfferData(_id);
   }


   /**
    * @dev get list of offers with filter included 
    * @dev Offer filter
    */
   function getOffers(
      uint256 startOfferId,
      uint256 dataPerPage,
      OfferSort memory sort,
      OfferListFilter memory _filter
   ) public view returns (OffersStructs.OfferItem[] memory) {

      require(dataPerPage > 0 && dataPerPage <= 100, statusMsg("DATA_PER_PAGE_PARAM_INVALID", toBytes32(dataPerPage)));

      if(sort.orderBy == "id" && sort.orderMode == OFFER_SORT_ASC){
        return  getOffersSortByIdsASC(startOfferId, dataPerPage, _filter);
      } 

      /*
      else if(sort.orderBy == "id" && sort.orderMode == OFFER_SORT_DESC) {
         return getOffersSortByIdsASC(startId, dataPerPage, _filter);
      }*/

      return getOffersSortByIdsDESC(startOfferId, dataPerPage, _filter);

    } //end fun 


    /**
     * getOffersSortByIdsDesc
     */
     function getOffersSortByIdsDESC(
         uint256 startOfferId,
         uint256 dataPerPage,
         OfferListFilter memory _filter
     ) private view returns (OffersStructs.OfferItem[] memory) {

         uint256 totalOffers = getDataStore().getTotalOffers();

         OffersStructs.OfferItem[] memory processedData = new OffersStructs.OfferItem[] (dataPerPage + 1);

         if(startOfferId == 0) {
            startOfferId = totalOffers;
         }

         for(uint256 i = startOfferId; i <= 0; i--){
            
            OffersStructs.OfferItem memory offerItem  = getOfferById(i);
            
            if(!computeOfferListFilter(offerItem, _filter)) {
               continue;
            }

            //add offer item into the array
            processedData[i] = offerItem;

            if(processedData.length >= dataPerPage){
               break;
            }
         } //end loop

         return processedData;
     } //end fun


     /**
     * getOffersSortByIdsASC
     */
     function getOffersSortByIdsASC(
         uint256 startOfferId,
         uint256 dataPerPage,
         OfferListFilter memory _filter
     ) private view returns (OffersStructs.OfferItem[] memory) {

         uint256 totalOffers = getDataStore().getTotalOffers();

         OffersStructs.OfferItem[] memory processedData = new OffersStructs.OfferItem[] (dataPerPage + 1);


         for(uint256 i = startOfferId; i <= totalOffers; i++){
            
            OffersStructs.OfferItem memory offerItem  = getOfferById(i);
            
            if(!computeOfferListFilter(offerItem, _filter)) {
               continue;
            }

            //add offer item into the array
            processedData[i] = offerItem;

            if(processedData.length >= dataPerPage){
               break;
            }
         } //end loop

         return processedData;
     } //end fun

     /**
      * computeOfferListFilter
      */
      function computeOfferListFilter(
         OffersStructs.OfferItem memory offerItem,
         OfferListFilter memory _filter
      ) public view returns(bool) {

         bool isEligible = true;

         //lets check filters 
         if(_filter.owner != address(0) && !(_filter.owner == offerItem.owner)){
            isEligible = false;
         }

         if(_filter.offerType.length > 0 && !(_filter.offerType == offerItem.offerInfo.offerType)){
            isEligible = false;
         }

         if(_filter.pricingMode.length > 0 && !(_filter.pricingMode == offerItem.pricingInfo.pricingMode)){
            isEligible = false;
         }

         if(_filter.countryCode.length > 0 && !(_filter.countryCode == offerItem.offerInfo.countryCode)) {
            isEligible = false;
         } //end if 

         //lets check offer rating
         uint offerRating = getDataStore().getOfferRating(offerItem.id);

         if(_filter.minRating > 0 && !(offerRating >= _filter.minRating)){
            isEligible = false;
         }


         return isEligible;
      } //end 

}  //end contract 