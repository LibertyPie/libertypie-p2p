/**
 * LibertyPie (https://libertypie.com)
 * @author LibertyPie <hello@libertypie.com>
 * factory_set_config_data.js
 */
 const Utils = require('../../classes/Utils');

//console.log(Utils.numToBytes32(15))
module.exports = {
    contract: 'Factory',
    method:   'setConfigData',
    data: [
        
        //minimum payment window 
        //key: value as [key,value]
        [ "MIN_PAYMENT_WINDOW",  Utils.numToBytes32(15) ],

        //key: value as [key,value]
        [ "MAX_SECURITY_DEPOSIT", Utils.numToBytes32(10) ],

        //key: value as [key,value]
        [ "MAX_REPUTATION", Utils.numToBytes32(10) ]
    ]
}