/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

/**
 * @dev assets struct Implementation
 */
contract AssetsStructs {
    
    /**
     * @dev asset struct item
     */
    struct AssetItem {
        uint256   id;
        address   contractAddress;
        uint8     decimals;
        bool      isPegged;
        address   peggedAssetGateway;
        string    originalName;
        string    originalSymbol;
        string    priceFeedProvider;
        address   priceFeedContract;
        bool      isEnabled;
        uint256   createdAt;
        uint256   updatedAt;
    }

}