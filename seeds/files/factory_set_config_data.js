/**
 * LibertyPie (https://libertypie.com)
 * @author LibertyPie <hello@libertypie.com>
 * factory_set_config_data.js
 */
 const Utils = require('../../classes/Utils');
 const truffleSeeder = require('@libertypie/truffle-seeder')

module.exports = {
    contract: 'Factory',
    method:   'setConfigData',
    data: [
        
        //minimum payment window 
        //key: value as [key,value]
        [ "MIN_PAYMENT_WINDOW", truffleSeeder.toBytes32(15) ],

        //key: value as [key,value]
        [ "MAX_SECURITY_DEPOSIT", truffleSeeder.toBytes32(10) ],

        //key: value as [key,value]
        [ "MAX_REPUTATION", truffleSeeder.toBytes32(10) ]
    ]
}