/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";

contract DappStore is StoreEditor  {

    //offer index mapping
    //offers data
    //format is mapping(adIndex => adStruct)
    //mapping(uint256 => OfferStruct) private OffersData;
    
    mapping(uint256 =>  mapping(bytes32 => bytes)) public OffersData;

    /**
     * @dev add data to offers
     * @param _index the index where the data will be stored, also offer id
     * @param _key the name of the value data to store
     * @param _data the actual data to store  
     */
    function addOfferData(uint256 _index, bytes32 _key, bytes memory _data) external onlyStoreEditor {
        OffersData[_index][_key] = _data;
    }


    /**
     * @dev payment types
     */
    // mapping()
}