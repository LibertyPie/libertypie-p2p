/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./IPriceFeed.sol";
import "../../Base.sol";

interface UniswapAnchoredView {
    function price(string calldata symbol) external view returns (uint);
}

contract OpenPriceFeed is Base, IPriceFeed {

    string public providerName = "Open Price Feed";

     //if the uniswap anchor contract is changed
    event uniswapAnchorContractChanged(address indexed _newAddress);

    //uniswap anchored view contract
    UniswapAnchoredView public  UNISWAP_ANCHORED_VIEW;

    /**
     * @dev initiate open price feed
     */
    function _initialize() private {
        
        uint256  chainId = getChainID();

        address feedContractAddress;
        

        //mainnet , default mainnet's address is  hardcoded in OpenPriceFeed.sol
        if(chainId  == 1){ feedContractAddress = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;  } // if ethereum mainnet
        else if(chainId == 3){ feedContractAddress = 0xBEf4E076A995c784be6094a432b9CA99b7431A3f; }  // if ropsten
        else if(chainId == 42){  feedContractAddress = 0xbBdE93962Ca9fe39537eeA7380550ca6845F8db7; } //if kovan
        else {
            //revert("OpenPriceFeed: Unknown cahinId, kindly use  ropsten, kovan or mainnet");
        }

        _setUniswapAnchorContract(feedContractAddress);
    }


    constructor() {
        _initialize();
    }

    /**
     * @dev update uniswap anchor contract
     * @param _newAddress  the new contract address
     */
    function _setUniswapAnchorContract(address _newAddress) private  {
        
        UNISWAP_ANCHORED_VIEW = UniswapAnchoredView(_newAddress);

        //emit event
        emit uniswapAnchorContractChanged(_newAddress);

    } //end  fun


    /**
     * @dev update uniswap anchor contract
     * @param _newAddress  the new contract address
     */
    function setUniswapAnchorContract(address _newAddress) external onlyAdmin ()  {
        _setUniswapAnchorContract(_newAddress);
    }

    /**
     * getLatestPrice
     */
    function getLatestPrice(string memory _symbol) public override view returns (uint256) {
        return UNISWAP_ANCHORED_VIEW.price(_symbol);
    } //end fun


    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     */
    function setAssetPriceFeedContract(string memory _asset, address _contract) public override onlyAdmin {}

}//end 