const PaymentMethodsDataArray = require("../files/PaymentMethods");
const ethers = require("ethers");
//var slugify = require('slugify');
const Utils = require("../../classes/Utils");
const Status = require("../../classes/Status");

module.exports = async ({
    contractInstance, 
    contractMethod, 
    argsArray,
    networkId
}) => {
  
    try {
        
        for(let paymentMehodInfoObj of PaymentMethodsDataArray){
            
            //lets get categoryName 
            let categoryName = paymentMehodInfoObj.name;
            let isCatEnabled = paymentMehodInfoObj.isEnabled;

            //let defaultOpts 
            let defaultOpts = paymentMehodInfoObj.defaultOptions || {};

            let categoryNameSlug = slugify(categoryName)

            //payment Method Categories 
            let paymentMethodCategories = this.getPaymentMethodCategories(deployedInstance);
        }
        
    } catch (e) {
        Utils.errorMsg(`seedPaymentMethodsData Error: ${e}`)
        console.log(e)
    }
    
}

//lets check if category exists 
getPaymentMethodCategories = async (contractInstance) => {
    try {

        //lets check if the category slug exists
        let result = await contractInstance.getPaymentMethodsCategories();

        console.log(result)

    } catch (e) {
        console.log(`getPaymentMethodCategories Error ${e.message}`,e)
        return Status.errorPromise(`getPaymentMethodCategories Error: ${e.message}`)
    }
}