const ConfigDataObj = require("./files/Config");
const PaymentMethodsDataArray = require("./files/PaymentMethods");
const ethers = require("ethers");
//var slugify = require('slugify');
const Utils = require("../classes/Utils");
const Status = require("../classes/Status");

module.exports =  class {

    getRegistry(){
        return [
            {
                file: "Config"
            },
            {   
                file:   "PaymentMethods",
                processor: "seedPaymentMethodsData"
            }
        ];
    }


    /**
     * genericSeedProcessor
     */
     async standardSeedProcessor(contract, method, args) {
         try {

             let result = contract.methods[method](args);

             console.log(result)
         } catch (e) {
              console.log(`standardSeedProcessor Error ${e.message}`,e)
            return Status.errorPromise(`standardSeedProcessor Error: ${e.message}`)
         }
     }

    /**
     * seed Payment methods 
     */
    async seedPaymentMethodsData(){
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
    static async getPaymentMethodCategories(factoryInst) {
        try {

            //lets check if the category slug exists
            let result = await factoryInst.getPaymentMethodsCategories();

            console.log(result)

        } catch (e) {
            console.log(`getPaymentMethodCategories Error ${e.message}`,e)
            return Status.errorPromise(`getPaymentMethodCategories Error: ${e.message}`)
        }
    }

}


