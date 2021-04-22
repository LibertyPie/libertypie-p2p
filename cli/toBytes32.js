#!/usr/bin/env node 

const ethers = require("ethers");
const process = require("process");
const colors = require("colors");


function run(){

    let arg = process.argv[2] || null

    if(arg == null || arg.toString().trim().length == 0){
        console.log(colors.red("argument is required"));
        return false;
    }

    arg = arg.trim()
    
    if (/[0-9]+/.test(arg)) {
        if(arg.toString().includes(".")){
            arg = Number.parseFloat(arg.toString());
        } else {
            arg = Number.parseInt(arg.toString());
        }
    }

    console.log(typeof arg)
    
    let byte32str = ethers.utils.formatBytes32String(arg)

    console.log(colors.green(byte32str));
}

run();