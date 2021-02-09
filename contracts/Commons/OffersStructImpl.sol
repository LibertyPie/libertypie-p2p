/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

/**
 * @dev offer struct Implementation
 */
contract OffersStructImpl {
    
    
    /**
     * @dev add data to offers
     * @param asset contract address
     * @param _type offer type, sell or buy offer
     * @param owner the offer owner or creator
     * @param pricingMode mode of pricing, either market or fixed
     * @param profitMargin if pricing mode is market, then profit margin in %
     * @param fixedPrice if pricing mode is fixed, then the fixed offer price
     * @param countryCode the two letter country code
     * @param currencyCode the two letter currency code
     * @param paymentTypeId the paymentTypeId
     * @param minTradeLimit minimum trade limit for this offer
     * @param maxTradeLimit maximum trade limit for this offer
     * @param hasSecurityDeposit wether security deposit is enabled
     * @param securityDepositRate if security deposit is enabled, then the required % 
     * @param paymentWindow the time within which payment has to be made before expires 
     * @param partnerMinRequiredTrades the minimum trades required by a partner
     * @param partnerMinReputation minimum reputation required by a partner
     * @param externalInfoHash ipfs or siaskynet has for payment terms and info
     * @param externalStoreId where the external info was stored
     * @param isEnabled is offer enabled
     * @param expiry if an expiry is set
     */
    struct OffersStruct {
        address  asset;
        string   _type;
        address  owner;
        string   pricingMode;
        uint256  profitMargin;
        uint256  fixedPrice;
        string   countryCode;
        string   currencyCode;
        uint256  paymentTypeId;
        uint256  minTradeLimit;
        uint256  maxTradeLimit;
        bool     hasSecurityDeposit;
        uint256  securityDepositRate;
        uint256  paymentWindow;
        uint256  partnerMinRequiredTrades;
        uint256  partnerMinReputation;
        string   externalInfoHash;
        int      externalStoreId;
        bool     isEnabled;
        uint256  expiry;
        mapping(bytes32 => bytes) extraData;
    }   
}