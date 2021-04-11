/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

/**
 * @dev offer struct Implementation
 */
contract TradesStructs {

    struct TradeInfo {
       uint256   id; 
       uint256   offerId;
       uint256   amount;
       address   asset;
       address   tradePartner;
       address   tradeGuardian;
       uint256   createdAt;
       uint256   expiresAt;
       boolean   isSuccess; 
    }


    struct TradeReview{
        uint256 id;
        uint256 tradeId;
        uint256 offerId;
        uint256 partnerRating;
        string  partnerCommentHash;
        uint256 guardianRating;
        string  guardianCommentHash;
        uint256 createdAt;
        uint256 updatedAt; 
    }

} //end contract