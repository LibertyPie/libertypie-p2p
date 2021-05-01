

const path = require('path')
//const PermissionManager = artifacts.require("../PermissionManager/PermissionManager");
//const EthernalStorage = artifacts.require("../Storage/Storage");
const Utils = require("../classes/Utils");
const fps  = require("fs/promises")
const process = require('process')
const sleep = require('sleep')

let deployerEnvInfo = {}
let deployedContractsLog = {}

let deployedDataFile = path.resolve(path.dirname(__dirname),"deployed.txt");

let sleepTime = 3;

module.exports = async ({getUnnamedAccounts, deployments, ethers, network}) => {

    const {deploy} = deployments;
    const accounts = await getUnnamedAccounts();

    let account = accounts[0];

    let networkName = network.name;

    deployerEnvInfo = {
        account
    }
    
    Utils.infoMsg(`Deploying with account: ${accounts[0]}`)

    Utils.infoMsg(`Deploying contract: PermissionManager`)

    let deployedPermissionManager = await deploy('PermissionManager', {
        from: account,
        log: true
    });

    //lets log the data
    deployedContractsLog["PermissionManager"] = deployedPermissionManager.address;

    printDeployedInfo("PermissionManager", deployedPermissionManager)

    Utils.infoMsg(`Sleeping for ${sleepTime} sec`)
    sleep.sleep(sleepTime);

    Utils.infoMsg(`Deploying contract: Storage`)

    let deployedStorage = await deploy('Storage', {
        from: account,
        args: [deployedPermissionManager.address],
        log: true
    });

    deployedContractsLog["Storage"] = deployedStorage.address;

    printDeployedInfo("Storage", deployedStorage)


    Utils.infoMsg(`Sleeping for ${sleepTime} sec`)
    sleep.sleep(sleepTime);


    Utils.infoMsg(`Deploying contract: Factory`)

    //deploy factory
    let deployedFactory = await deploy('Factory', {
        from: account,
        args: [deployedPermissionManager.address, deployedStorage.address],
        log: true
    });

    deployedContractsLog["Factory"] = deployedFactory.address;

    printDeployedInfo("Factory", deployedFactory);


    Utils.infoMsg(`Sleeping for ${sleepTime} sec`)
    sleep.sleep(sleepTime);


    Utils.infoMsg(`Permitting Factory (Main) contract (${deployedFactory.address}) as permitted storage editor (STORAGE_EDITOR)`)

    //let permResult = await deployedPermissionManager.grantRole("STORAGE_EDITOR",deployedFactory.address);

     const _permissionManager = await ethers.getContract('PermissionManager', account);

     let permResult = await _permissionManager.grantRole("STORAGE_EDITOR",deployedFactory.address);

     Utils.successMsg(`STORAGE_EDITOR permission granted for ${deployedFactory.address}`)


    //lets save log
    let logDataToSave = {}

    logDataToSave[networkName] = {
        env: deployerEnvInfo,
        info: deployedContractsLog,
        date: (new Date()).toString()
     }

    //lets write log
    await fps.writeFile(deployedDataFile, JSON.stringify(logDataToSave, null, 2));
 
};

module.exports.tags = ['PermissionManager','Storage','Factory'];

function printDeployedInfo(contractName,deployedObj){
    Utils.successMsg(`${contractName} deployment successful`)
    Utils.successMsg(`${contractName} contract address: ${deployedObj.address}`)
    Utils.successMsg(`${contractName} txHash: ${deployedObj.transactionHash}`)
    Utils.successMsg(`${contractName} gas used: ${deployedObj.receipt.cumulativeGasUsed}`)
    console.log()
}