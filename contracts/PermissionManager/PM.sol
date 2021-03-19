/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/
pragma solidity ^0.7.6;


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

    bool pmInitialized;
    
    address _owner;

    constructor() {
      _owner = msg.sender;
    }

    /**
     * initializePM
     */
    function initializePermissionManager(address _permissionManager) internal {
      
      require(!pmInitialized, "PERMISSION_MANAGER_ALREADY_INITIALIZED");

      require(_owner == msg.sender, "ONLY_CONTRACT_OWNER_CAN_INITIALIZE");
      
      PERMISSION_MANAGER = IPermissionManager(_permissionManager);

      //lets add contract as permitted to write on storage 
      //PERMISSION_MANAGER.grantRole("STORAGE_EDITOR", address(this));

      emit SetPermissionManager(_permissionManager);

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