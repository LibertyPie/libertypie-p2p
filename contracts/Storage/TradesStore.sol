/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;
import "./StoreEditor.sol";
import "../Commons/TradesStruct.sol";


contract TradesStore is StoreEditor  {

    //total trades
    uint256 totalTrades;

    //Trades 
    mapping(uint256 => TradesStruct.TradeInfo) private Trades;


    /**
     * @dev get next TradeId
     */
     function getNextTradeId() external onlyStoreEditor returns(uint256) {
        return (++totalTrades);
     }

    /**
     * getTotalTrades
     */
    function getTotalTrades() external view  returns (uint256){
        return totalTrades;
    }

    /**
     * getTrade
     */
    function getTrade(uint256 _id) public view returns(TradesStruct.TradeInfo) {
        return Trades[_id];
    }

    /**
     * saveTradeInfo
     */
     function saveTradeInfo(uint256 _id, TradesStruct.TradeInfo _tradeInfo) public onlyStoreEditor {
        Trades[_id] = _tradeInfo;
     } //end fun 
}