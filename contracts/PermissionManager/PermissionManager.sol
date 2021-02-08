/**
 * LibertyPie (https://libertypie.com)
 * @author LibertyPie <hello@libertypie.com>
 * SPDX-License-Identifier: MIT
 */
pragma solidity ^0.6.2;

contract PermissionManager {

    event GrantRole(string roleName, address indexed _address);
    event Revoke(string roleName, address indexed _address);

    //default role 
    string SUPER_ADMIN_ROLE = "SUPER_ADMIN";
    string MODERATOR_ROLE = "MODERATOR";
    string ADMIN_ROLE = "ADMIN";
    
    //roles
    mapping(string => mapping(address => bool)) public Roles;
    
    constructor(address _owner) public {

        if(_owner  == address(0)){
            _owner = msg.sender;
        }

        //add deployer as a super admin
        Roles[SUPER_ADMIN_ROLE][_owner] = true;
        Roles[MODERATOR_ROLE][_owner] = true;
        Roles[ADMIN_ROLE][_owner] = true;
    }

    /**
     * @dev is super admin
     */
     function isSuperAdmin(address _address) public view returns (bool) {
        return Roles[SUPER_ADMIN_ROLE][_address];
     }

    /**
    * isAdmin
    */
    function isAdmin(address _address) public view  returns(bool) {
        return hasRole(ADMIN_ROLE,_address) || hasRole(SUPER_ADMIN_ROLE,_address);
    }

    /**
     * isModerator
     */
    function isModerator(address _address) public view returns (bool) {
      return hasRole(MODERATOR_ROLE,_address) || isAdmin(_address);
    }

    /**
     * @dev super admin only modifier
     */
     modifier onlySuperAdmin() {
        require(isSuperAdmin(msg.sender) == true,"ONLY_SUPER_ADMINS_ALLOWED");
        _;
     }


    /**
     * @dev add Role
     * @param roleName roleName
     */
    function addRole(string memory roleName)  public onlySuperAdmin {
        
        require(bytes(roleName).length > 0,"ROLE_NAME_REQUIRED");

        // add role 
        Roles[roleName][msg.sender] = true;

        emit GrantRole(roleName,msg.sender);
    }//end fun  


    /**
     * grant role to an address
     */
    function grantRole(string memory roleName, address _address) public onlySuperAdmin {

        //grant the role 
         Roles[roleName][_address] = true;

         emit GrantRole(roleName,_address);
    } //end fun

    /**
     * hasRole
     */
    function hasRole(string memory roleName, address _address) public view returns(bool) {
        return Roles[roleName][_address];
    }

    /**
     * remove user from role
     */
    function revoke(string calldata roleName, address _address) external onlySuperAdmin {
        delete Roles[roleName][_address];
        emit Revoke(roleName,_address);
    }

}   
