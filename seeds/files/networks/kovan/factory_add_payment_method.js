/*
* LibertyPie Project (https://libertypie.com)
* @author https://github.com/libertypie (hello@libertypie.com)
* @license SPDX-License-Identifier: MIT
*/

const Utils = require("../../../../classes/Utils");
const dataProcessor = require("../../../processors/PaymentMethodProcessor");

module.exports = {

    contract: "Factory",
    method: "",
    processor: dataProcessor,

    data: [
        {
            category: "Bank Transfers",
            isEnabled: true,

            children: [
                {
                    name: "Bank Transfer",
                    countries: [],
                    continents: [],
                    minPaymentWindow: Utils.fromMinutesToMilli(30), 
                    maxPaymentWindow: Utils.fromDaysToMilli(1), 
                    isEnabled: true
                },

                {
                    name: "SEPA",
                    countries: [],
                    continents: ["EU"],
                    minPaymentWindow: Utils.fromDaysToMilli(1),
                    maxPaymentWindow: Utils.fromDaysToMilli(5),
                    isEnabled: true
                }

            ]
        },

        {
            category: "Online Transfers",
            isEnabled: true,

            defaultOptions: {
                countries: [],
                continents: [],
                minPaymentWindow:  Utils.fromMinutesToMilli(15), 
                maxPaymentWindow:   Utils.fromMinutesToMilli(30), 
                isEnabled: true
            },
            
            children: [
                "Abra",
                "AdvCash",
                "Airline Tickets"
            ]
        },

        {
            category: "Cash Payments / Remittance",
            isEnabled: true,

            defaultOptions: {
                countries: [],
                continents: [],
                minPaymentWindow:  Utils.fromDaysToMilli(1), 
                maxPaymentWindow:   Utils.fromDaysToMilli(5), 
                isEnabled: true
            },

            children: [
                "Amazon Cash",
                "Bancolombia Cash Deposit",
                "Bitcoin ATM"
            ]  
        }
    ]
}