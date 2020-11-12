// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

import "./Oracles/OpenPriceFeed.sol";

contract PriceFeed {

    OpenPriceFeed _openPriceFeed;

    /**
     * @dev getPrice
     */
     function getPriceUSD(string memory _symbol) private view returns (uint256) {
        (uint256 _price) = _openPriceFeed.getLatestPrice(_symbol);
        return _price;
     }

}  //end contract 