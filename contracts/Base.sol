/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";
import "./Storage/StoreProxy.sol";
import "./Config.sol";

contract Base is PM, Config {
    //store Proxy
    IStorage _dataStore = StoreProxy(address(this)).getIStorage();

   /**
     * @dev status msg
     * @param _text status text  
     * @param _params he parameters 
     */
    function statusMsg(string _text, string _params) public view  returns(string) {
        return string(abi.encodePacked("XPIE:", _text , ":", _params));
    }


    /**
     * @dev status msg
     * @param _text status text  
     * @param _params he parameters 
     */
    function statusMsg(string _text, bytes _params) public view  returns(string) {
        return statusMsg(_text,string(_params));
    }

    /**
     * @dev status msg
     * @param _text status text  
     */
    function statusMsg(string _text) public view returns(string) {
        return statusMsg(_text,"");
    }

}