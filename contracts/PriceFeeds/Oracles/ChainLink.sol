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

    event SetFeedContract(bytes32 indexed _chain, bytes32 indexed _assetPair, address indexed _contract);

    //lets create storage for the contracts 
    //chainId => (assetPair => contractAddress)
    mapping(bytes32 => mapping(bytes32 => address)) private feedContracts;
    uint256[] private chainIds;


      /**
     * @dev set priceFeed contract
     * @param _chain the chain id
     * @param _assetPair the asset usd pair to fetch price feed
     * @param _contract feed contract
     */
    function _setFeedContract(bytes32 _chain, bytes32 _assetPair, address _contract) private {
        setFeedContract(_chain, _assetPair, _contract);
    }

    /**
     * @dev set priceFeed contract
     * @param _chain the chain id
     * @param _assetPair the asset usd pair to fetch price feed
     * @param _contract feed contract
     */
    function setFeedContract(bytes32 _chain, bytes32 _assetPair, address _contract) public onlyAdmin {
        feedContracts[_chain][_assetPair] = _contract;

        //emit event
        emit SetFeedContract(_chain,_assetPair,_contract);
    }

    /**
     * getAggregatorV3Interface
     */
     function getPriceFeedContract(bytes32 _assetPair) public view returns(address) {
        
        //lets get chainId 
        address _contract = feedContracts[_chain][_assetPair];

        require(_contract != address(0), statusMsg("CHAIN_FEED_CONTRACT_MISSING",_assetPair));

        return _contract;
     }

    /**
     * getLastestPrice
     */
    function getLatestPrice(bytes32 _assetPair) public view returns(uint256) {
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(getPriceFeedContract(_assetPair));

         (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return uint256(price);
    } //end get price

    /**
     * @dev get all feed contracts 
     */
    function getAllFeedContracts() public view returns (unint256[], address[]) {
        
    }//end fun 
}//end contract