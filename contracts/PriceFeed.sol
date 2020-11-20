// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

import "./Oracles/OpenPriceFeed.sol";

contract PriceFeed is  OpenPriceFeed {

   /**
   * @dev get latest price in usd
   */
   function getPriceUSD(string memory _symbol) public view returns (uint256) {
      (uint256 _price) = OpenPriceFeed.getLatestPrice(_symbol);
      return _price;
   }

   /**
    * configure open price feed contract
    */
    function configureOpenPriceFeed(address _contractAddress) internal {
      OpenPriceFeed._setUniswapAnchorContract(_contractAddress);
    }

}  //end contract 