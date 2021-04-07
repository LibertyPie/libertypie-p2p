const ethers = require("ethers");

module.exports =  {
    data: [
         //minimum payment window 
        { "MIN_PAYMENT_WINDOW": ethers.utils.formatBytes32String(15) },
    
        { "MAX_SECURITY_DEPOSIT": ethers.utils.formatBytes32String(10) },

        { "MAX_REPUTATION": ethers.utils.formatBytes32String(10) }
    ]
}