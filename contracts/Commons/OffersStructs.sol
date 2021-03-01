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
contract OffersStructs {
    
    struct OfferInfo {
        address asset;
        bytes32 offerType;
        bytes32 countryCode;
        bytes32 currencyCode;
        uint256  paymentMethod;
        string  externalInfoHash;
        int     externalStoreId;
        bool    isEnabled;
        uint256 expiry;
    }

    struct PricingInfo {
        bytes32   pricingMode;
        uint256   profitMargin;
        uint256   fixedPrice;
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
    
    struct OfferItem {
        uint256      id;
        address      owner;
        OfferInfo    offerInfo;
        PricingInfo  pricingInfo;
        TradeInfo    tradeInfo;
    }  


    //offer index Item
    struct OfferIndexesItem {
       mapping(bytes32 => uint256[]) ids;
    } 

}