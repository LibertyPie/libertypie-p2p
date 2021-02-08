// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "../PermissionManager/PM.sol";

interface UniswapAnchoredView {
    function price(string calldata symbol) external view returns (uint);
}

contract OpenPriceFeed is PM {

    //if the uniswap anchor contract is changed
    event uniswapAnchorContractChanged(address indexed _newAddress);

    //uniswap anchored view contract
    UniswapAnchoredView public  UNISWAP_ANCHORED_VIEW;

    constructor() public {

        //default to ethereum mainnet 
        address  _contractAddress = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;

        UNISWAP_ANCHORED_VIEW = UniswapAnchoredView(_contractAddress);
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
    function getLatestPrice(string memory _symbol) internal view returns (uint256) {
        return UNISWAP_ANCHORED_VIEW.price(_symbol);
    } //end fun


}//end 