const ConfigDataObj = require("./Config");

module.exports =  class {

    //seed config data
    static async seedConfigData(deployedInstance) {
        try {

       Object.keys(ConfigDataObj).forEach(async (key) => {
            
            let value = ConfigDataObj[key];

            let result = await deployedInstance.setConfig(key, value);

            console.log(`Seeding Config Data Success: ${result.tx}`)
            
        });

        } catch(e) {
        errorMsg(`seedConfigData Error: ${e}`)
        console.log(e)
        }
    }

    
}


