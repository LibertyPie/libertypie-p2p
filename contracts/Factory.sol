// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

//PriceFeed is called in Assets.sol
import "./PriceFeed.sol";
import "./Assets.sol";
import  "./PermissionManager/PermissionManager.sol";
import "./PermissionManager/PM.sol";

//import "./PaymentTypes/PaymentTypesCore.sol";

import "./PaymentMethods.sol";

//import  "./Oracles/OpenPriceFeed.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

contract Factory is  Assets,  PaymentMethods, PriceFeed, Context {
    
    constructor() public {

        //initiate Permission Manager contracts
        PM._setPermissionManager(address(new PermissionManager(_msgSender())));

        // PaymentTypes  Core contract address
        //PaymentTypes._setPaymentTypesCoreAddress(address(new PaymentTypesCore()));

        //configure  open price feed
        configureOpenPriceFeed();

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


    function getChainID() internal pure returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

} //end contract