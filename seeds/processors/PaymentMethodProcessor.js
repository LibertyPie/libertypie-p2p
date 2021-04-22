const PaymentMethodsDataArray = require("../files/factory_add_payment_method");
const ethers = require("ethers");
//var slugify = require('slugify');
const Utils = require("../../classes/Utils");
const Status = require("../../classes/Status");

module.exports = async ({
    contractName,
    contractInstance, 
    contractMethod, 
    argsArray,
    networkId,
    web3,
    web3Account
}) => {
  
    try {

        //payment Method Categories 
        let pmCatsStatus = await getPaymentMethodCategories(contractInstance);

        if(pmCatsStatus.isError()){
            return pmCatsStatus;
        }

        let pmCatsDataArray = pmCatsStatus.data;
            
        for(let index in argsArray){

            let argDataArray = argsArray[index];
            
            /*/lets get categoryName 
            let categoryName = paymentMehodInfoObj.name;
            let isCatEnabled = paymentMehodInfoObj.isEnabled;

            //let defaultOpts 
            let defaultOpts = paymentMehodInfoObj.defaultOptions || {};

            //let categoryNameSlug = slugify(categoryName)
            */
            
            //payment Method Categories 
          

            //yarn seeder-run

            let categoryName = (argDataArray.category || "")

            //lets check if the category exists, if not we insert it 
            for(let chainCatInfo of pmCatsDataArray){
                
            }

            console.log("categoryName: ", categoryName)
            
           
        }
        
        return Status.errorPromise()
    } catch (e) {
        Utils.errorMsg(`seedPaymentMethodsData Error: ${e}`)
        console.log(e)

         return Status.errorPromise()
    }
    
}

//lets check if category exists 
getPaymentMethodCategories = async (contractInstance) => {
    try {

        //lets check if the category slug exists
        let resultsArray = await contractInstance.methods.getPaymentMethodsCategories().call();

        //lets process the results 
        let processedResults = []

        for(let i in resultsArray){

            let catInfo = resultsArray[i]

            if(catInfo.id == 0 || catInfo.name == ""){
                continue;
            }

            processedResults.push(catInfo)
        }

        return Status.successPromise("",processedResults)
    } catch (e) {
        console.log(`getPaymentMethodCategories Error ${e.message}`,e)
        return Status.errorPromise(`getPaymentMethodCategories Error: ${e.message}`)
    }
}