/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;


contract Utils {

    /**
     * @dev get chain id
     */
    function getChainID() public view returns (uint256) {
        uint256 id;
        assembly { id := chainid() }
        return id;
    } //end fun
    
    /**
     * @dev status msg
     * @param _text status text  
     * @param _params he parameters 
     */
    function statusMsg(string memory _text, string memory _params) public pure returns(string memory) {
        return string(abi.encodePacked("XPIE:", _text , ":", _params));
    }


    /**
     * @dev status msg
     * @param _text status text  
     * @param _params he parameters 
     */
    function statusMsg(string memory _text, bytes32  _params) public pure returns(string memory) {
        return statusMsg(_text,string(abi.encodePacked(_params)));
    }


    /**
     * @dev status msg
     * @param _text status text  
     */
    function statusMsg(string memory _text) public pure returns(string memory) {
        return statusMsg(_text,string(abi.encodePacked("")));
    }

 
    function toBytes32(uint256 _data) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_data));
    }

    function toBytes32(string memory _data) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_data));
    }

    function toBytes32(address _data) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_data));
    }

}