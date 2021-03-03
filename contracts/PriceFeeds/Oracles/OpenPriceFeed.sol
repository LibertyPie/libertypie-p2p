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

     //if the uniswap anchor contract is changed
    event uniswapAnchorContractChanged(address indexed _newAddress);

    //uniswap anchored view contract
    UniswapAnchoredView public  UNISWAP_ANCHORED_VIEW;

    /**
     * @dev initiate open price feed
     */
    function _initiate() private {
        
        uint256  chainId = getChainID();


    }

    /**
     * @dev update uniswap anchor contract
     * @param _newAddress  the new contract address
     */
    function _setUniswapAnchorContract(address _newAddress) internal  {
        
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
    function getLatestPrice(string memory _symbol) public view returns (uint256) {
        return UNISWAP_ANCHORED_VIEW.price(_symbol);
    } //end fun


    /**
     * @dev set priceFeed contract
     * @param _asset the asset  to fetch price feed
     * @param _contract feed contract
     */
    function setPriceFeedContract(string memory _asset, address _contract) public onlyAdmin {}

}//end 