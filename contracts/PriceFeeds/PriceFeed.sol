/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./Oracles/IPriceFeed.sol";
import "./Oracles/ChainLink.sol";
import "./Oracles/OpenPriceFeed.sol";
import "../Base.sol";

contract PriceFeed is Base, ChainLink {

   /*
   event SetAssetPriceFeedContract( string indexed _assset, address indexed _contract);

   IPriceFeed ACTIVE_PRICE_FEED_PROVIDER;
   
   string ACTIVE_PRICE_FEED_PROVIDER_NAME;

   mapping(string => address) public priceFeedOracles;


   constructor() {

      address chainLinkAddress = address(new ChainLink());

      //create the price feed oracles
      priceFeedOracles["chainlink"] = chainLinkAddress;
      priceFeedOracles["open_price_feed"] = address(new OpenPriceFeed());

      //set active contract 
      ACTIVE_PRICE_FEED_PROVIDER = IPriceFeed(chainLinkAddress);
      ACTIVE_PRICE_FEED_PROVIDER_NAME = "chainlink";
   }


   /**
    * @dev chang provider
    * @param _provider (example chainlink)
    *
    function priceFeedSetActiveProvider(string memory _provider)  public onlyAdmin {

      require(toBytes32(_provider) == toBytes32("chainlink") || 
              toBytes32(_provider) == toBytes32("open_price_feed"),
              statusMsg("UNKNOWN_PROVIDER",_provider)
      );

      address _providerContractAddr = priceFeedOracles[_provider];

      require(_providerContractAddr != address(0),statusMsg("PROVIDER_CONTRACT_ADDRESS_INVALID"));

      ACTIVE_PRICE_FEED_PROVIDER = IPriceFeed(_providerContractAddr);

      ACTIVE_PRICE_FEED_PROVIDER_NAME = _provider;
    } //end fun 


   /**
    * @dev get latest price
    * @param _asset asset symbol
    *
   function getLatestPrice(string memory _asset) public view returns (uint256) {
      return ACTIVE_PRICE_FEED_PROVIDER.getLatestPrice(_asset);
   } //end fun 


   /**
    * get latestPrice by provider
    * @param  _provider provider name eg. chainlink
    * @param _asset  asset symbol eg. eth
    *
    function getLatestPriceByProvider(string memory _provider,string memory _asset) public view returns (uint256) {
      
      require(toBytes32(_provider) == toBytes32("chainlink") || 
         toBytes32(_provider) == toBytes32("open_price_feed"),
         statusMsg("UNKNOWN_PROVIDER",_provider)
      );

      address _providerContractAddr = priceFeedOracles[_provider];

      require(_providerContractAddr != address(0),statusMsg("PROVIDER_CONTRACT_ADDRESS_INVALID"));

      IPriceFeed _providerContract = IPriceFeed(_providerContractAddr);

      return _providerContract.getLatestPrice(_asset);
    } //end fun 

    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     *
    function setAssetPriceFeedContract(string memory _asset, address _contract) public onlyAdmin {
      ACTIVE_PRICE_FEED_PROVIDER.setAssetPriceFeedContract(_asset,_contract);
      emit SetAssetPriceFeedContract(_asset,_contract);
    }
    */

}  //end contract 