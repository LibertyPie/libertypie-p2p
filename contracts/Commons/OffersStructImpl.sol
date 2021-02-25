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
    
    struct OfferInfo {
        address asset;
        bytes32 offerType;
        bytes32 countryCode;
        bytes32 currencyCode;
        string  externalInfoHash;
        int     externalStoreId;
        bool    isEnabled;
        uint256 expiry;
    }

    struct PricingInfo {
        string   pricingMode;
        uint256  profitMargin;
        uint256  fixedPrice;
        uint256  paymentTypeId;
    }

    struct TradeInfo {
        uint256  minTradeAmountLimit;
        uint256  maxTradeAmountLimit;
        bool     hasSecurityDeposit;
        uint256  securityDepositRate;
        uint256  paymentWindow;
        uint256  partnerMinimumTrades;
        uint256  partnerMinimumReputation;
    }
    
    struct OffersStruct {
        address  owner;
        OfferInfo offerInfo;
        PricingInfo pricingInfo;
        TradeInfo OfferTradeInfo;
        mapping(bytes32 => bytes) extraData;
    }   
}