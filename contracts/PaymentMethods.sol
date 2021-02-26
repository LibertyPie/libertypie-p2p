/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./PermissionManager/PM.sol";

import "./Storage/StoreProxy.sol";
import "./Commons/PaymentMethodsStructs.sol";


contract PaymentMethods is PM {

    event AddPaymentMethodCategory(uint256 _id);
    event RemovePaymentMethodCategory(uint256 _id);
    event UpdatePaymentMethodCategory(uint256 categoryId);
    event AddPaymentMethod(uint256 _id);
    event UpdatePaymentMethod(uint256 _id);
    event RemovePaymentMethod(uint256 _id);

    IStorage dataStore = StoreProxy(address(this)).getIStorage();


    /**
     * @dev getTotalPaymentMethods
     */
     function getTotalPaymentMethods() public view returns(uint256) {
         return dataStore.getTotalPaymentMethods();
     } //end fun 

    /**
     * @dev getTotalPaymentMethods
     */
     function getTotalPaymentMethodsCategories() public view returns(uint256) {
         return dataStore.getTotalPaymentMethodsCategories();
     } //end fun 


    /**
    * @dev add a new payment type category
    * @param name category name in string
    * @param countries supported countries, leave empty to target all countries
    * @return uint256 new category  id
   */
   function addPaymentMethodCategory(
       string calldata name,
       string[] memory countries,
       bool isEnabled
    ) external  onlyAdmin() returns(uint256) {
     
        uint256 catId = dataStore.getNextPaymentMethodCategoryId();

        PaymentMethodsStructs.CategoryItem memory _dataToSave = PaymentMethodsStructs.CategoryItem(
            catId,
            name,
            countries,
            isEnabled
        );

        dataStore.savePaymentMethodsCategoryData(
            catId,
            _dataToSave
        );

        emit AddPaymentMethodCategory(catId);

        return catId;
   } //end fun 


    /**
   * @dev delete a cetegory
   * @param _id category  id
   */
   function removePaymentMethodCategory(uint256 _id) external onlyAdmin() {
        dataStore.deletePaymentMethodsCategoryData(_id);
        emit RemovePaymentMethodCategory(_id);
   } //end fun 


    /**
    * @dev add a new payment type category
    * @param categoryId the category id
    * @param newCategoryName  new category name to change
    * @param countries supported countries leave empty to target all
    * @param isEnabled if the category is enabled or not
    */
    function updatePaymentMethodCategory(
        uint256 categoryId,  
        string calldata newCategoryName,
        string[] memory countries,
        bool isEnabled
    ) external  onlyAdmin() {
      
       PaymentMethodsStructs.CategoryItem memory _dataToSave = PaymentMethodsStructs.CategoryItem(
            categoryId,
            newCategoryName,
            countries,
            isEnabled
        );

        dataStore.savePaymentMethodsCategoryData(
            categoryId,
            _dataToSave
        );

        emit UpdatePaymentMethodCategory(categoryId);
    } //end fun 

    /**
   * @dev add a new payment method
   * @param name payment method name
   * @param categoryId category id for the new payment  type
   * @return uint256
   */
   function addPaymentMethod(
       string memory name, 
       uint256 categoryId,
       uint256 minPaymentWindow,
       uint256 maxPaymentWindow,
       string[] memory countries,
       bool isEnabled 
    ) external  onlyAdmin() returns(uint256) {

        //lets  check if categoryId exists 
        require(categoryId >=0 && categoryId <= getTotalPaymentMethodsCategories(),"XPIE:UNKNOWN_CATEGORY");

        //avoid totalPaymentTypes++
        //counting starts from 1, so index 0 wont exist
        uint256 id = dataStore.getNextPaymentMethodId();

        PaymentMethodsStructs.PaymentMethodItem memory _dataToSave = PaymentMethodsStructs.PaymentMethodItem(
            id, 
            name, 
            categoryId,
            minPaymentWindow,
            maxPaymentWindow,
            countries,
            isEnabled
        );

        dataStore.savePaymentMethodData(
            id,
            _dataToSave
        );

        emit AddPaymentMethod(id);

        return id;
   } //end 


    /**
    * @dev getPaymentMethod
    * @param _id paymentMethod id
    */
    function getPaymentMethod(uint256 _id) public view returns (PaymentMethodsStructs.PaymentMethodItem memory) {
        return dataStore.getPaymentMethodData(_id);
    }

   /**
   * @dev remove  a payment method 
   * @param _id  the payment method id
   */
   function removePaymentMethod(uint256 _id) external  onlyAdmin() { 
      dataStore.deletePaymentMethodData(_id); 
      emit RemovePaymentMethod(_id);
   }


    /**
   *  @dev update  payment type info
   *  @param paymentMethodId old paymentType id
   *  @param name the new name of the paymentType
   *  @param  categoryId the new category id of the payment type
   */
   function updatePaymentMethod(
       uint256 paymentMethodId, 
       string calldata name, 
       uint256 categoryId,
       uint256 minPaymentWindow,
       uint256 maxPaymentWindow,
       string[] memory countries,
       bool isEnabled 
    ) external  onlyAdmin()  {
        
        //lets check if 
         require(paymentMethodId >= 0 && paymentMethodId  <= getTotalPaymentMethods(),"XPIE:UNKNOWN_PAYMENT_METHOD");
   
        PaymentMethodsStructs.PaymentMethodItem memory _dataToSave = PaymentMethodsStructs.PaymentMethodItem(
            paymentMethodId, 
            name, 
            categoryId,
            minPaymentWindow,
            maxPaymentWindow,
            countries,
            isEnabled
        );

        dataStore.savePaymentMethodData(
            paymentMethodId,
            _dataToSave
        );

        emit UpdatePaymentMethod(paymentMethodId);
   } //end fun


   /**
   *  @dev get all payment types categories 
   *  @return  (PaymentMethodsStructs.CategoryItem[] memory) CategoryNames Array with category id as array index
   */
   function  getPaymentMethodsCategories() public view returns (PaymentMethodsStructs.CategoryItem[] memory) {
    
      uint256 totalCategories = getTotalPaymentMethodsCategories(); 
      PaymentMethodsStructs.CategoryItem[] memory  categoriesArray = new PaymentMethodsStructs.CategoryItem[] (totalCategories);
      
      //mapping index starts with 1, not  0
      for(uint256 i = 0; i <= totalCategories; i++ ){
        categoriesArray[i] = dataStore.getPaymentMethodsCategoryData(i);
      }

      return categoriesArray;
   } //end fun 


  /* 
   * @dev get payment types using it category id
   * @param categoryId uint256 category id 
   * @return PaymentMethodsStructs.PaymentMethodItem[] memory
   */
   function getPaymentMethodsByCategory(uint256 categoryId) external view returns( PaymentMethodsStructs.PaymentMethodItem[] memory ) {

      uint256 totalPaymentMethods = getTotalPaymentMethods();

      //lets fetch the  payment types ids
      PaymentMethodsStructs.PaymentMethodItem[] memory paymentMethodsArray   = new PaymentMethodsStructs.PaymentMethodItem[] (totalPaymentMethods);

        for(uint256  i = 0; i <= totalPaymentMethods; i++){

            PaymentMethodsStructs.PaymentMethodItem memory paymentMethodData =  getPaymentMethod(i);

            if(paymentMethodData.categoryId == categoryId && paymentMethodData.isEnabled == true){
                paymentMethodsArray[i] = paymentMethodData;
            }
        }

        return paymentMethodsArray;
   }  //end fun


   /**
   * @dev get all payment types 
   */
   function getPaymentMethods() public view returns( PaymentMethodsStructs.PaymentMethodItem[] memory ) {

      uint256 totalPaymentMethods = getTotalPaymentMethods();

      PaymentMethodsStructs.PaymentMethodItem[] memory paymentMethodsArray   = new PaymentMethodsStructs.PaymentMethodItem[] (totalPaymentMethods);

      for(uint256 i = 0; i <= totalPaymentMethods; i++ ){
         paymentMethodsArray[i] = getPaymentMethod(i);
      }

      return paymentMethodsArray;
   }

   /**
    * @dev Fetch payment types and categories in a single query
    */
   function getPaymentMethodsAndCategories() 
        external 
        view 
        returns (PaymentMethodsStructs.CategoryItem[] memory,  PaymentMethodsStructs.PaymentMethodItem[] memory) 
    {
      return (getPaymentMethodsCategories(),getPaymentMethods());
   }//end 
   
}//end contract