/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;

import  "./PermissionManager.sol";

interface IPermissionManager {
    function isSuperAdmin(address _address) external view  returns(bool);
    function isAdmin(address _address) external view  returns(bool);
    function isModerator(address _address) external view returns(bool);
    function isStorageEditor(address _address) external view  returns(bool);
    function hasRole(string memory roleName, address _address) external view returns (bool);
    function grantRole(string memory roleName, address _address) external;
}


contract PM {

    event SetPermissionManager(address indexed _contract);

    IPermissionManager public PERMISSION_MANAGER;

    //wether the contract has been initialized or not
    //this prevents users from calling the setup method in the contract
    bool pmInitialized;


    /**
     * @dev set up permission manager on contract installation
     */
    function installPermissionManager() internal {

        //initialized must be false to continue
        require(!pmInitialized,"XPIE:CONTRACT_ALREADY_INITIALIZED");

        //set permisssion manager contract
        PERMISSION_MANAGER = IPermissionManager(address(new PermissionManager(msg.sender, address(this))));

        //set initialized to true
        pmInitialized = true;
    } 

    /**
     * @dev  set permission manager contract
     */
    function setPermissionManager(address _newAddress) external onlySuperAdmin () {
      
      PERMISSION_MANAGER = IPermissionManager(_newAddress);

      emit SetPermissionManager(_newAddress);
    }

    /**
    * @dev superAdminOnly - a modifier which allows only super admin 
    */
    modifier onlySuperAdmin () {
      require(PERMISSION_MANAGER.isSuperAdmin(msg.sender), "ONLY_SUPER_ADMINS_ALLOWED" );
      _;
    }

    /**
    * OnlyAdmin 
    * This also allows super admins
    */
    modifier onlyAdmin () {
      require(PERMISSION_MANAGER.isAdmin(msg.sender), "ONLY_ADMINS_ALLOWED");
      _;
    }

    /**
    * OnlyModerator
    */
    modifier onlyModerator() {
      require(PERMISSION_MANAGER.isModerator(msg.sender), "MODERATORS_ONLY_ALLOWED" );
      _;
    }

    //permissions 
    modifier onlyStoreEditor() {
      require(PERMISSION_MANAGER.isStorageEditor(msg.sender),"ONLY_STORAGE_EDITORS_ALLOWED");
      _;
    }
    
    /**
     * hasRole
     */
    function hasRole(string memory roleName, address _address) public view returns(bool){
      return PERMISSION_MANAGER.hasRole(roleName,_address);
    }



    /**
     * grant role
     */
    function grantRole(string memory roleName, address _address) public onlySuperAdmin {
      PERMISSION_MANAGER.grantRole(roleName, _address);
    }


  
    
} //end function