#!/usr/bin/env node 

const ethers = require("ethers");
const process = require("process");
const colors = require("colors");
const web3 = require("web3")
const Seeder = require("../seed/Seeder");
const secrets = require("../.secrets.js");
const Web3 = require("web3")
const { ArgumentParser } = require('argparse');
const { version } = require('../package.json');
const truffleConfig = require("../truffle-config");
const path = require("path");
var Web3Net = require('web3-net');


run = async () => {
    
     
    const parser = new ArgumentParser({
      description: 'Seed migration'
    });
     
    parser.add_argument('-v', '--version', { action: 'version', version });
    parser.add_argument('-c', '--contract', { default: 'all', help: 'the contract to seed, default is all' });
    parser.add_argument('-n', '--network', { default: 'development', help: 'the network in truffle-config to use, default is development' });

    let args= parser.parse_args()

    let contract = args["contract"];
    

    if(contract == null || contract.toString().trim().length == 0 || contract.toLowerCase() == "all"){
        contract = "";
    }

    let netName = args["network"];
    
    //lets get the network profile 
    let networks = truffleConfig.networks || {}

    if(!(netName in networks)){
        console.error(`Network '${netName}' was not found in truffle-config`)
        return false;
    }

    let networkInfo = networks[netName];

    let provider;

    if('provider' in networkInfo){
        provider = networkInfo.provider();
    } else {

       let protocol = (networkInfo.port == 443) ? "https" : "http";
       provider = `${protocol}://${networkInfo.host}:${networkInfo.port}`;
    }


    //return false;

    let web3 = new Web3(provider);
    let web3Net = new Web3Net(provider);

    //console.log(web3)

    //lets get network id
    let networkId = await web3Net.getId();

    let _seeder = new Seeder();

    //lets get the registry
    let seedRegistryArray = _seeder.getRegistry();

    for(let seedInfo of seedRegistryArray){
        
       //lets get 
       let contractName = seedInfo.contract || "";
       let methodName = seedInfo.method || "";

        if(contractName.length == 0){ throw new Error(`Unknown seed contract ${contractName}`) }

        if(methodName.length == 0){ throw new Error(`Unknown seed method ${methodName}`) } 

        let contractInfo; 
        
        try{ contractInfo = require(`../build/contracts/${contractName}.json`); } catch(e){ throw e;}

        let contractAbi = contractInfo.abi;

        let cNetworks = contractInfo.networks || {};

        let cNetworkInfo = cNetworks[networkId.toString()] || {}

        if(Object.keys(cNetworkInfo).length == 0){
            throw new Error(`It seems the contract '${contractName}' has not been deployed, kindly deploy contract before seeding the data`)
        }

        let contractAddress = cNetworkInfo.address;

        console.log(`Seeding data to contract ${contractName} at ${contractAddress}`)

        //lets load the contract in web3js
        let contractObj = new web3.eth.Contract(contractAbi,contractAddress);

        //console.log(contractObj)

        //lets methodName
        let seedResult = _seeder[methodName](contractObj);
    } //end for 
}


run();