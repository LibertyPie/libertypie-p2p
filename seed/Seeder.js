const ConfigDataObj = require("./Config");
const PaymentMethodsDataArray = require("./PaymentMethods");
const ethers = require("ethers");
var slugify = require('slugify')


module.exports =  class {

    factoryInstance = null;

    constructor(_factoryInstance) {
        this.factoryInstance = _factoryInstance;
    }

    //seed config data
    async seedConfigData() {
        try {

          for(let key of Object.keys(ConfigDataObj)){
            
            let value = ConfigDataObj[key];

            try {
                
                console.log(`Inserting Config ${key}:${value} -> ${ethers.utils.formatBytes32String(value.toString())}`)
                

                let result = await this.factoryInstance.setConfigData(key, ethers.utils.formatBytes32String(value.toString()));

                console.log(` Seeding Config Data Success txHash: ${result.tx}`)
                
                //console.log(result)

                //console.log(deployedInstance)
            } catch(e) {
                console.log(`seedConfigData Error: ${e}`,e)
            }
        }

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


