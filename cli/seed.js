#!/usr/bin/env node 

const ethers = require("ethers");
const process = require("process");
const colors = require("colors");
const web3 = require("web3")
const Seeder = require("../seed/Seeder");
const secrets = require("../.secrets.js");
const web3js = require("web3")
const { ArgumentParser } = require('argparse');
const { version } = require('../package.json');

run = async () => {
     
    const parser = new ArgumentParser({
      description: 'Seed migration'
    });
     
    parser.add_argument('-v', '--version', { action: 'version', version });
    parser.add_argument('-c', '--contract', { default: 'all', help: 'the contract to seed, default is all' });

    console.dir(parser.parse_args());

    /*
    if(arg == null || arg.toString().trim().length == 0 || arg.toLowerCase() == "all"){
        arg = "";
    }*/
    
}

run();