/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

/**
 * @dev offer struct Implementation
 */
contract ConfigsStructs {

    struct ConfigItem {
        bytes32 _key;
        bytes32 _value;
    }
}