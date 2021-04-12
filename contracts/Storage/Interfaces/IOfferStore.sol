/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "../../Commons/OffersStructs.sol";

interface IOfferStore {

    function getNextOfferId() external returns(uint256);
    function getTotalOffers() external view  returns (uint256);
    function saveOfferData(uint256  _id, OffersStructs.OfferItem memory _data) external;
    function getOfferData(uint256 _id) external view returns(OffersStructs.OfferItem memory);
    function deleteOfferData(uint256 _id) external;

     function getOfferRating(uint256 offerId) public view returns (uint);
    function setOfferRating(uint256 offerId, uint rating) external;

    //indexes
    function setOfferIndex(bytes32 _indexName, bytes32 _key, uint256 _id) external;
}