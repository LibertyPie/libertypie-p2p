const ConfigDataObj = require("./Config");
const ethers = require("ethers");


module.exports =  class {

    //seed config data
    static async seedConfigData(deployedInstance) {
        try {

          for(let key of Object.keys(ConfigDataObj)){
            
            let value = ConfigDataObj[key];

            try {
                
                console.log(`Inserting Config ${key}:${value} -> ${ethers.utils.formatBytes32String(value.toString())}`)
                

                let result = await deployedInstance.setConfigData(key, ethers.utils.formatBytes32String(value.toString()));

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

    
}


