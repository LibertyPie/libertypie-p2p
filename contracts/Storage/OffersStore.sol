/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/OffersStructs.sol";


contract OffersStore is StoreEditor, OffersStructs  {

    //format is mapping(index => OffersStruct)
    mapping(uint256 =>  OfferItem) private OffersData;

    /**
     * @dev totalOffers
     */
    uint256 private totalOffers;

    /**
     * @dev generate or get next offerId
     */
     function getNextOfferId() external onlyStoreEditor returns(uint256) {
        return (totalOffers += 1);
     }

    /**
     * getTotalOffers
     */
    function getTotalOffers() external view  returns (uint256){
        return totalOffers;
    }

   
    function saveOfferData(
        uint256  id, 
        address owner,
        address  asset,
        bytes32  offerType,
        bytes32  pricingMode,
        uint256  profitMargin,
        uint256  fixedPrice,
        bytes32  countryCode
     
    ) external onlyStoreEditor {
      
    }

}