// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

contract PermissionManager is Context, AccessControl {


    bytes32 ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 MODERATOR_ROLE =   keccak256("MODERATOR_ROLE");


    constructor(address _owner)  public {

      if(_owner  == address(0)){
        _owner = _msgSender();
      }

      //make deployer superAdmin
      _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        
      //add default roles
      _setupRole(ADMIN_ROLE,_owner);
      _setupRole(MODERATOR_ROLE, _owner);
      
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
      return hasRole(MODERATOR_ROLE,_address) || isAdmin(_address);
    }

    /**
     * addNewRole
     */
     function addRole(bytes32 _roleName, address _memberAddress) public {
       require(isSuperAdmin(_msgSender()),"ONLY_SUPER_ADMINS_ALLOWED");
        super.grantRole(_roleName,_memberAddress);
     }

    /**
    * override the grantRole
    */
    function grantRole(bytes32 role, address account) public override virtual {}

}