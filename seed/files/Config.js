const ethers = require("ethers");

module.exports =  {
    contract: "Factory",
    method: "setConfigData",
    data: [
        
        //minimum payment window 
        //key: value as [key,value]
        [ "MIN_PAYMENT_WINDOW",  ethers.utils.formatBytes32String(15) ],

        //key: value as [key,value]
        [ "MAX_SECURITY_DEPOSIT", ethers.utils.formatBytes32String(10) ],

        //key: value as [key,value]
        [ "MAX_REPUTATION", ethers.utils.formatBytes32String(10) ]
    ]
}