// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

//PriceFeed is called in Assets.sol
import "./PriceFeed.sol";
import "./Assets.sol";
import  "./PermissionManager/PermissionManager.sol";
import "./PermissionManager/PM.sol";

import "./Storage/StoreEditor.sol";

import "./PaymentMethods.sol";
import "./Utils.sol";

contract Factory is Utils, Assets,  PaymentMethods, PriceFeed, StoreEditor {
    
    constructor() {

        //initiate Permission Manager contracts
        PM._setPermissionManager(address(new PermissionManager(msg.sender)));

        // PaymentTypes  Core contract address
        //PaymentTypes._setPaymentTypesCoreAddress(address(new PaymentTypesCore()));

        //configure  open price feed
        configureOpenPriceFeed();


        //lets set store editor address
        //lets add pm role,
        // this should be the address of the contract which will be
        // allowed to write to storage
        grantRole(STORAGE_EDITOR_ROLE,address(this));

    } //end fun 

    
    /**
     * @dev configure OpenPriceFeed
     */
    function configureOpenPriceFeed() private {

        uint256  chainId = getChainID();

        address feedContractAddress;
        

        //mainnet , default mainnet's address is  hardcoded in OpenPriceFeed.sol
        if(chainId  == 1){ feedContractAddress = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;  } // if ethereum mainnet
        else if(chainId == 3){ feedContractAddress = 0xBEf4E076A995c784be6094a432b9CA99b7431A3f; }  // if ropsten
        else if(chainId == 42){  feedContractAddress = 0xbBdE93962Ca9fe39537eeA7380550ca6845F8db7; } //if kovan
        else {
            //revert("OpenPriceFeed: Unknown cahinId, kindly use  ropsten, kovan or mainnet");
        }

        //if we had the address then lets set it
        if(feedContractAddress != address(0)){
            //setUniswapAnchorContract is  in OpenPriceFeed which is inherited by PriceFeed 
            PriceFeed.configureOpenPriceFeed(feedContractAddress);
        }

    } //end fun 

} //end contract