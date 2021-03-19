#!/usr/bin/env node 

const ethers = require("ethers");
const process = require("process");
const colors = require("colors");


function run(){

    const arg = process.argv[2] || null

    if(arg == null || arg.toString().trim().length == 0){
        console.log(colors.red("argument is required"));
        return false;
    }

    if (typeof value === 'number') {
        if(arg.toString().includes(".")){
            arg = Number.parseFloat(arg.toString());
        } else {
            arg = Number.parseInt(arg.toString());
        }
    }

    let byte32str = ethers.utils.formatBytes32String(arg)

    console.log(colors.green(byte32str));
}

run();