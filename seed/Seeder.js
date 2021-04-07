const ConfigDataObj = require("./files/Config");
const PaymentMethodsDataArray = require("./files/PaymentMethods");
const ethers = require("ethers");
var slugify = require('slugify')


module.exports =  class {

    getRegistry(){
        return [
            {
                method: "seedConfigData",
                contract: "Factory"
            },
            {
                method: "seedPaymentMethodsData",
                contract: "Factory"
            }
        ];
    }

    //seed config data
    async seedConfigData(contractObj) {
        try {

          
        } catch(e) {
            errorMsg(`seedConfigData Error: ${e}`)
            console.log(e)
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
            errorMsg(`seedPaymentMethodsData Error: ${e}`)
            console.log(e)
        }
    }

    //lets check if category exists 
    static async getPaymentMethodCategories() {
        try {

            //lets check if the category slug exists
            let result = await this.factoryInstance.getPaymentMethodsCategories();

            console.log(result)

        } catch (e) {
            console.log(`getPaymentMethodCategories Error ${e.message}`,e)
            return Status.errorPromise(`getPaymentMethodCategories Error: ${e.message}`)
        }
    }

}


