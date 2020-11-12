// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

contract PermissionManager is Context, AccessControl {


    bytes32 ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 MODERATOR_ROLE =   keccak256("MODERATOR_ROLE");


    constructor()  public {

      //make deployer superAdmin
      _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        
      //add default roles
      addRole(ADMIN_ROLE,_msgSender());
      addRole(MODERATOR_ROLE,_msgSender());
      
    }  //end  

    /**
    * isSuperAdmin
    */
    function isSuperAdmin(address _address) public view  returns(bool) {
      return  super.hasRole(DEFAULT_ADMIN_ROLE,_address);
    }
     
    /**
    * isAdmin
    */
    function isAdmin(address _address) public view  returns(bool) {
        return super.hasRole(ADMIN_ROLE,_address) || super.hasRole(DEFAULT_ADMIN_ROLE,_address);
    }

    /**
     * isModerator
     */
    function isModerator(address _address) public view returns (bool) {
      return hasRole(MODERATOR_ROLE,_address) || super.hasRole(DEFAULT_ADMIN_ROLE,_address);
    }

    /**
    * OnlyAdmin 
    * This also allows super admins
    *
    modifier onlyAdmins () {
      require( isAdmin(_msgSender()) );
      _;
    }

    /**
    * OnlyModerator
    *
    modifier onlyModerators() {
      require(  isModerator(_msgSender()) );
      _;
    }
    */

    /**
     * addNewRole
     */
     function addRole(bytes32 _roleName, address _memberAddress) public {
       require(isSuperAdmin(_msgSender()),"only super admins can add role");
        super.grantRole(_roleName,_memberAddress);
     }

    /**
    * override the grantRole
    */
    function grantRole(bytes32 role, address account) public override virtual {}

}