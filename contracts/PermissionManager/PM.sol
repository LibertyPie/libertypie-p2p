// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;


interface IPermissionManager {
    function isSuperAdmin(address _address) external view  returns(bool);
    function isAdmin(address _address) external view  returns(bool);
    function isModerator(address _address) external view returns (bool);
}

contract PM {

    IPermissionManager _permissionManager;

    function _setAddress(address _newAddress) internal {
        _permissionManager = IPermissionManager(_newAddress);
    }

    function setAddress(address _newAddress) external onlySuperAdmins () {

    }

    /**
     * onlySuperAdmin - a modifier which allows only super admin 
    */
     modifier onlySuperAdmins () {
         require( _permissionManager.isSuperAdmin(msg.sender) );
         _;
     }

    /**
    * OnlyAdmin 
    * This also allows super admins
    */
    modifier onlyAdmins () {
      require( _permissionManager.isAdmin(msg.sender) );
      _;
    }

    /**
    * OnlyModerator
    */
    modifier onlyModerators() {
      require( _permissionManager.isModerator(msg.sender) );
      _;
    }

} //end function