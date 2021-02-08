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
    function hasRole(string roleName, address _address) external view returns (bool);
    function grantRole(string calldata roleName, address _address) external;
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
    function setPermissionManager(address _newAddress) external superAdminOnly () {
      _setPermissionManager(_newAddress);
    }

    /**
    * @dev superAdminOnly - a modifier which allows only super admin 
    */
     modifier superAdminOnly () {
         require( PERMISSION_MANAGER.isSuperAdmin(msg.sender), "ONLY_SUPER_ADMINS_ALLOWED" );
         _;
     }

    /**
    * OnlyAdmin 
    * This also allows super admins
    */
    modifier adminOnly () {
      require( PERMISSION_MANAGER.isAdmin(msg.sender), "ONLY_ADMINS_ALLOWED");
      _;
    }

    /**
    * OnlyModerator
    */
    modifier moderatorOnly() {
      require( PERMISSION_MANAGER.isModerator(msg.sender), "MODERATORS_ONLY_ALLOWED" );
      _;
    }
    
    /**
     * hasRole
     */
    function hasRole(string roleName, address _address) external view returns(bool){
      return PERMISSION_MANAGER.hasRole(roleName,_address);
    }

    /**
     * grant role
     */
    function grantRole(string calldata roleName, address _address) external superAdminOnly {
      PERMISSION_MANAGER.grantRole(roleName, _address);
    }
    
} //end function