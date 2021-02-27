/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../../Commons/OffersStructs.sol";

interface IOfferStore {

    function getNextOfferId() external returns(uint256);
    function getTotalOffers() external view  returns (uint256);
    function saveOfferData(uint256  _id, OffersStructs.OfferItem memory _data) external;
    function getOfferData(uint256 _id) external view returns(OffersStructs.OfferItem memory);
    function deleteOfferData(uint256 _id) external;
    
}