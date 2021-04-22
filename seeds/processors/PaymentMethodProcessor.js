const PaymentMethodsDataArray = require("../files/factory_add_payment_method");
const ethers = require("ethers");
//var slugify = require('slugify');
const Utils = require("../../classes/Utils");
const Status = require("../../classes/Status");

var pmCatsDataArray = null;

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

        pmCatsDataArray = pmCatsStatus.data;
            
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

            let chainCategoryId;

            Utils.infoMsg(`Checking if category ${categoryName} exists`)

            //lets get cat info by name
            let chainCatInfoStatus = getCategoryInfoByName(categoryName)

            if(chainCatInfoStatus.isError()){
                Utils.errorMsg(`Failed to get category Info for ${categoryName}`)
                return chainCatInfoStatus;
            }

            let chainCatInfo = chainCatInfoStatus.data || [];

            //if empty data, then lets insert the data
            if(!(chainCatInfo == null || chainCatInfo.length == 0) && chainCatInfo.id > 0){
                chainCategoryId = chainCatInfo.id;

                Utils.infoMsg(`Category ${categoryName} exists with id: ${chainCategoryId}`)
            } else {
                
                Utils.infoMsg(`Category ${categoryName} does not exists adding to chain`)
                
                //at this point, lets add category
                console.log("Lol Adding category")
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

//get cat info by name
getCategoryInfoByName = async (categoryName) => {

    if(pmCatsDataArray == null){
          //payment Method Categories 
        let pmCatsStatus = await getPaymentMethodCategories(contractInstance);

        if(pmCatsStatus.isError()){
            Utils.errorMsg(pmCatsStatus.msg)
            return pmCatsStatus;
        }

        pmCatsDataArray = pmCatsStatus.data;
    } //end if 

    let catNameSlug = slugify(categoryName)

    for(let catInfo of pmCatsDataArray){
        
        let chainCatName = slugify(catInfo.name);

        if(chainCatName.length > 0 && chainCatName == catNameSlug){
            return Status.successPromise("", catInfo)
        }
    }

    return Status..successPromise("", null);
} //end fun 