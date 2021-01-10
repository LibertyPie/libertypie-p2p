/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
interface IPermissionManager {
    function isSuperAdmin(address _address) external view  returns(bool);
    function isAdmin(address _address) external view  returns(bool);
    function isModerator(address _address) external view returns (bool);
}

contract PM {

    IPermissionManager public PERMISSION_MANAGER;

    /**
     * @dev  set permission manager contract
     */
    function _setPermissionManager(address _newAddress) internal {
        PERMISSION_MANAGER = IPermissionManager(_newAddress);
    }

    /**
     * @dev  set permission manager contract
     */
    function setPermissionManager(address _newAddress) external onlySuperAdmins () {
      _setPermissionManager(_newAddress);
    }

    /**
     * onlySuperAdmin - a modifier which allows only super admin 
    */
     modifier onlySuperAdmins () {
         require( PERMISSION_MANAGER.isSuperAdmin(msg.sender), "ONLY_SUPER_ADMINS_ALLOWED" );
         _;
     }

    /**
    * OnlyAdmin 
    * This also allows super admins
    */
    modifier onlyAdmins () {
      require( PERMISSION_MANAGER.isAdmin(msg.sender), "ONLY_ADMINS_ALLOWED");
      _;
    }

    /**
    * OnlyModerator
    */
    modifier onlyModerators() {
      require( PERMISSION_MANAGER.isModerator(msg.sender), "ONLY_MODERATORS_ALLOWED" );
      _;
    }

} //end function