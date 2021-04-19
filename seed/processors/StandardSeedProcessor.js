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
    
    for(let _argArray of argsArray) {
        try {

            console.log(contractMethod[contractMethod])
            let result = await contractInstance.methods[contractMethod](..._argArray);

            console.log(result)
            return Status.successPromise("", result);

        } catch (e) {
            console.log(`standardSeedProcessor Error ${e.message}`,e)
            return Status.errorPromise(`standardSeedProcessor Error: ${e.message}`)
        }
    } //end loop
}