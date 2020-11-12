// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

interface UniswapAnchoredView {
    function price(string memory symbol) external view returns (uint);
}

contract OpenPriceFeed is PM {

    //if the uniswap anchor contract is changed
    event uniswapAnchorContractChanged(address indexed _newAddress);

    /**
     * @dev uniswap price feed anchor contract
     */
    address public uniswapPriceFeedContract = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;

    UniswapAnchoredView  uniswapAnchoredView;

    /**
     * @dev update uniswap anchor contract
     */
    function setUniswapAnchorContract(address _newAddress) public onlyAdmins {
         
        uniswapPriceFeedContract = _newAddress;

        //emit event
        emit uniswapAnchorContractChanged(_newAddress);
    } //end  fun

    /**
     * getLatestPrice
     */
    function getLatestPrice(string memory _symbol) public view returns (uint256) {
        return UniswapAnchoredView(uniswapPriceFeedContract).price(_symbol);
    } //end fun

}//end 