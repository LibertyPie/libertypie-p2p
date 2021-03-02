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
    mapping(uint256 => mapping(bytes32 => address)) private feedContracts;
    uint256[] private chainIdsArray;


      /**
     * @dev set priceFeed contract
     * @param _chainId the chain id
     * @param _assetPair the asset usd pair to fetch price feed
     * @param _contract feed contract
     */
    function _setFeedContract(uint256 _chainId, bytes32 _assetPair, address _contract) private {
        setFeedContract(_chainId, _assetPair, _contract);
    }

    /**
     * @dev set priceFeed contract
     * @param _chainId the chain id
     * @param _assetPair the asset usd pair to fetch price feed
     * @param _contract feed contract
     */
    function setFeedContract(uint256 _chainId, bytes32 _assetPair, address _contract) public onlyAdmin {
        
        feedContracts[_chainId][_assetPair] = _contract;

        uint256 chainIdIndex;

        //lets check if the chainId exists in the chainIds array
        for(uint i = 1; i <= chainIdsArray.length; i++){

        }

        //emit event
        emit SetFeedContract(_chain,_assetPair,_contract);
    } //end fun 

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