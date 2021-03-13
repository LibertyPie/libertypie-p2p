/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

interface IPriceFeed {
    //string public providerName;
    function getLatestPrice(string memory _asset) external view returns(uint256);
    function setAssetPriceFeedContract(string memory _asset, address _contract) external;
}