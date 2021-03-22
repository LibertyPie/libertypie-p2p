/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

module.exports = class utils {

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
}