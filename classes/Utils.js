/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

const colors = require("colors");

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
         console.log()
      }

      static infoMsg(msg){
         console.log()
         console.log(`==>> %c${colors.bold.blue(msg)}`,"font-size: x-large")
         console.log()
      }


      static errorMsg(msg){
         console.log()
         console.log(`==>> %c${colors.bold.red(msg)}`,"font-size: x-large")
         console.log()
      }


}