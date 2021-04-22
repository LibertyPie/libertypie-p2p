const PaymentMethodsDataArray = require("../files/factory_add_payment_method");
const ethers = require("ethers");
//var slugify = require('slugify');
const Utils = require("../../classes/Utils");
const Status = require("../../classes/Status");
const slugify = require('slugify')

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

        console.log(pmCatsDataArray)
            
        for(let index in argsArray){

            let pmDataInfo = argsArray[index];

            //yarn seeder-run

            let categoryName = (pmDataInfo.category || "")
            let isCategoryEnabled = (pmDataInfo.isEnabled || true)

            let chainCategoryId;

            Utils.infoMsg(`Checking if category ${categoryName} exists`)

            //lets get cat info by name
            let chainCatInfoStatus = await getCategoryInfoByName(categoryName)

            if(chainCatInfoStatus.isError()){
                Utils.errorMsg(`Failed to get category Info for ${categoryName}`)
                return chainCatInfoStatus;
            }

            let chainCatInfo = chainCatInfoStatus.data || [];

            //if empty data, then lets insert the data
            if(!(chainCatInfo == null || chainCatInfo.length == 0) && chainCatInfo.id > 0){
                
                chainCategoryId = parseInt(chainCatInfo.id);

                Utils.infoMsg(`Category ${categoryName} exists with id: ${chainCategoryId}`)
            } else {
                
                Utils.infoMsg(`Category ${categoryName} does not exists adding to chain`)

                 let addPaymentCategoryResult = await contractInstance.methods.addPaymentMethodCategory(categoryName, isCategoryEnabled)
                                            .send({from: web3Account});


                if(!addPaymentCategoryResult.status){
                    Utils.errorMsg(`Failed to add category: '${categoryName}', txHash: ${addPaymentCategoryResult.transactionHash}`)
                    continue
                }


                chainCategoryId = addPaymentCategoryResult.events.AddPaymentMethodCategory.returnValues[0];

                chainCategoryId = parseInt(chainCategoryId);
                
                //at this point, lets add category
               Utils.infoMsg(`Category name ${categoryName} added, id: ${chainCategoryId} , txHash: ${addPaymentCategoryResult.transactionHash}`)

               //lets add to this list pmCatsDataArray
               pmCatsDataArray[chainCategoryId] = {id: chainCategoryId, name: categoryName};
            }            

            //paymentGatewayDefaultOpts
            let pmDefaultOpts = pmDataInfo.defaultOptions || null;

            //lets get category children
            let categoryChildrenArray = (pmDataInfo.children || [])


            //lets now loop the children 
            for(let ci in categoryChildrenArray) {

                let paymentMethodInfo = categoryChildrenArray[ci];

                if(typeof paymentMethodInfo == 'string'){

                    if(defaultOptions == null){
                        throw new Error(`Category defaultOptions parameter is required if a child is a string at category ${categoryName}, child ${paymentMethodInfo}`)
                    }

                    pmDefaultOpts['name'] = paymentMethodInfo;
                    paymentMethodInfo = pmDefaultOpts;
                } //end if 

                console.log("paymentMethodInfo ==> ", paymentMethodInfo)
            }//end loop
        }//end loop
        
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

    return Status.successPromise("", null);
} //end fun 