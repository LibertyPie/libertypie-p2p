/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./IPriceFeed.sol";
import "../../Base.sol";
import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";


contract ChainLink is IPriceFeed, Base {

    string public providerName = "ChainLink";


    //lets create storage for the contracts 
    //assetPair => contractAddress
    mapping(string  => address) public feedsContracts;
    
    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     */
    function _setPriceFeedContract(string memory _asset, address _contract) private {
        setAssetPriceFeedContract(_asset, _contract);
    }

    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     */
    function setAssetPriceFeedContract(string memory _asset, address _contract) public override onlyAdmin {
        //lets get chain id 
        feedsContracts[_asset] = _contract;
    } //end fun 

    /**
     * getAggregatorV3Interface
     */
    function getPriceFeedContract(string memory _asset) public view returns(address) {
        
        //lets get chainId 
        address _contract = feedsContracts[_asset];

        require(_contract != address(0), statusMsg("CHAIN_FEED_CONTRACT_MISSING",_asset));

        return _contract;
    }

    /**
     * @dev get latest price
     * @param _asset the asset which we need latest price for
     */
    function getLatestPrice(string memory _asset) public override  view returns(uint256) {
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(getPriceFeedContract(_asset));

         (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return uint256(price);
    } //end get price

}//end contract