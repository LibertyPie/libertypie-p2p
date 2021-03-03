/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

interface IPriceFeed {
    function getLatestPrice(string memory _asset) public view returns(uint256);
    function setPriceFeedContract(string memory _asset, address _contract) external;
}