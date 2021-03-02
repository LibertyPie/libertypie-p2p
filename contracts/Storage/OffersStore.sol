/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/OffersStructs.sol";


contract OffersStore is StoreEditor  {

    //format is mapping(index => OffersStruct)
    mapping(uint256 =>  OffersStructs.OfferItem) private OffersData;

    
    //OfferIndexes 
    mapping(bytes32 => mapping(bytes32 => uint256[])) public OffersIndexes;


    /**
     * @dev totalOffers
     */
    uint256 private totalOffers;

    /**
     * @dev generate or get next offerId
     */
     function getNextOfferId() external onlyStoreEditor returns(uint256) {
        return (++totalOffers);
     }

    /**
     * getTotalOffers
     */
    function getTotalOffers() external view  returns (uint256){
        return totalOffers;
    }

    /**
     * @dev save offer data
     * @param _id the offer id
     * @param _data the offer data
     */
    function saveOfferData(uint256  _id, OffersStructs.OfferItem memory _data) external onlyStoreEditor {
      OffersData[_id] = _data;
    } //end fun


    /**
     * get offer by id
     * @param _id offer id 
     * @return OffersStructs.OfferItem
     */
     function getOfferData(uint256 _id) external view returns(OffersStructs.OfferItem memory) {
        return OffersData[_id];
     } //end fun

    /**
     * delete offer data
     * @param _id offer id 
     */
     function deleteOfferData(uint256 _id) external onlyStoreEditor {
         delete  OffersData[_id];
     } //end 

    /**
    * @dev setOfferIndex
    * @param _indexName eg. toBytes32('OFFERS_BY_COUNTRY');
    * @param _key eg. us (country code)
    * @param _id the offer Id 
    */
    function setOfferIndex(bytes32 _indexName, bytes32 _key, uint256 _id) external onlyStoreEditor {
        OffersIndexes[_indexName][_key].push(_id);
    } //end fun 

    /**
    * @dev check if indexes contains an ID
    * @param _indexName eg. toBytes32('OFFERS_BY_COUNTRY');
    * @param _key eg. us (country code)
    * @param _id the offer Id 
    */
    function indexesHasId(bytes32 _indexName, bytes32 _key, uint256 _id) public view returns(bool) {
        return false;
    }
} //end contract