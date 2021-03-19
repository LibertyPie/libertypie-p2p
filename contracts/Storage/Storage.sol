/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./BasicStore.sol";
import "./OffersStore.sol";
import "./StoreEditor.sol";
import "./PaymentMethodsStore.sol";
import "./AssetsStore.sol";
import "./ConfigStore.sol";

contract Storage is
        StoreEditor, 
        BasicStore, 
        OffersStore, 
        PaymentMethodsStore,
        AssetsStore,
        ConfigStore
{
    
    /**
     * @param _permissionManager accept permission manager contract address
     */
    constructor(address _permissionManager) {
        setPermissionManager(_permissionManager);
    }

}   