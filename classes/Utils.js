/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

const colors = require("colors");
const _uweb3 = new (require('web3'))
const BN = require('bn.js');

module.exports = class Utils {

    /**
     * fromDaysToMilli
     */
    static fromDaysToMilli(noOfDays) {
        return (60 * 60 * 24 * noOfDays * 1000);
    }

    /**
     * fromMinutesToMilli
     */
     static fromMinutesToMilli(noOfMinutes){
        return (60  * noOfMinutes * 1000);
     }

    /**
     * fromHoursToMilli
     */
     static fromHoursToMilli(noOfHours){
        return (60  * 60 * noOfHours * 1000);
     }


      static successMsg(msg){
         console.log()
         console.log(`==>> %c${colors.bold.green(msg)}`,"font-size: x-large")
      }

      static infoMsg(msg){
          console.log()
         console.log(`==>> %c${colors.bold.blue(msg)}`,"font-size: x-large")
      }


      static errorMsg(msg){
          console.log()
         console.log(`==>> %c${colors.bold.red(msg)}`,"font-size: x-large")
      }


      static web3EncodeParam(dataType, data){
         return  _uweb3.eth.abi.encodeParameter(dataType,data);
      }

      static numToBytes32(num){
          var bn = new BN(num).toTwos(256);
         return this.padToBytes32(bn.toString(16));
      }


      static padToBytes32(n) {
         while (n.length < 64) {
            n = "0" + n;
         }
         return "0x" + n;
      }


      
}