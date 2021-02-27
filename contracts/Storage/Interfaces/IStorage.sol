
/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./IPaymentMethodsStore.sol";
import "./IAssetStore.sol";
import "./IOfferStore.sol";

interface IStorage is IPaymentMethodsStore, IAssetStore,IOfferStore {


    /**
     * Basic Store setters
     */
    function setUint256(bytes32 _key, uint256 _data) external;
    function setInt256(bytes32 _key, int256 _data) external;
    function setString(bytes32 _key, string calldata _data) external;
    function setBool(bytes32 _key, bool _data) external;
    function setAddress(bytes32 _key, address _data) external;
    function setBytes(bytes32 _key, bytes memory _data) external;

    /**
     * Basic store getters
     */
    function getUint256(bytes32 _key) external view returns(uint256);
    function getInt256(bytes32 _key) external view returns(int256);
    function getBool(bytes32 _key) external view returns(bool);
    function getAddress(bytes32 _key) external view returns(address);
    function getString(bytes32 _key) external view returns(string memory);

}