/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/OffersStructs.sol";


contract TradesStore is StoreEditor  {

      //TradeStats 
    mapping(uint256 => TradesStruct.Stats) private TradeStats;
    
}