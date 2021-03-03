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

contract PriceFeed is Base {

   IPriceFeed PROVIDER_CONTRACT;

   mapping(string => address) public priceFeedOracles;


   constructor() {

      address chainLinkAddress = new ChainLink();

      //create the price feed oracles
      priceFeedOracles["chainlink"] = chainLinkAddress;
      priceFeedOracles["open_price_feed"] = new OpenPriceFeed();

      //set active contract 
      PROVIDER_CONTRACT = IPriceFeed(chainLinkAddress);
   }


   /**
    * @dev chang provider
    * @param _provider (example chainlink)
    */
    function updateProvider(string memory _provider)  public onlyAdmin {

      require(bytes32(_provider) == "chainlink" || bytes32(_provider) == "open_price_feed", statusMsg("UNKNOWN_PROVIDER",_provider));

      address _providerContract = priceFeedOracles[_provider];

      require(_providerContract != address(0),statusMsg("PROVIDER_CONTRACT_ADDRESS_INVALID"));

      PROVIDER_CONTRACT = IPriceFeed(_providerContract);
    } //end fun 


   /**
    * @dev get latest price
    * @param _asset asset symbol
    */
   function getLatestPrice(string memory _asset) public view returns (uint256) {
      return PROVIDER_CONTRACT.getLatestPrice(_asset);
   } //end fun 


    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     */
    function setPriceFeedContract(string memory _asset, address _contract) public onlyAdmin {
      PROVIDER_CONTRACT.setPriceFeedContract(_asset,_contract);
    }

}  //end contract 