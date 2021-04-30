

const path = require('path')
//const PermissionManager = artifacts.require("../PermissionManager/PermissionManager");
//const EthernalStorage = artifacts.require("../Storage/Storage");
const Utils = require("../classes/Utils");
const fps  = require("fs/promises")
const process = require('process')

let deployerEnvInfo = {}
let deployedContracts = {}

let deployedDataFile = path.resolve("../deployed.txt");

module.exports = async ({getUnnamedAccounts, deployments}) => {

    const {deploy} = deployments;
    const accounts = await getUnnamedAccounts();

    let account = accounts[0];
    
    Utils.infoMsg(`Deploying with account: ${accounts[0]}`)

    Utils.infoMsg(`Deploying contract: PermissionManager`)

    let deployedPermissionManager = await deploy('PermissionManager', {
        from: account,
        log: true
    });

    printDeployedInfo("PermissionManager", deployedPermissionManager)

    Utils.infoMsg(`Deploying contract: Storage`)

    let deployedStorage = await deploy('Storage', {
        from: account,
        args: [deployedPermissionManager.address],
        log: true
    });

    printDeployedInfo("Storage", deployedStorage)
};

module.exports.tags = ['PermissionManager','Storage','Factory'];

function printDeployedInfo(contractName,deployedObj){
    Utils.successMsg(`${contractName} deployment successful`)
    Utils.successMsg(`${contractName} contract address: ${deployedObj.address}`)
    Utils.successMsg(`${contractName} txHash: ${deployedObj.transactionHash}`)
    Utils.successMsg(`${contractName} gas used: ${deployedObj.receipt.cumulativeGasUsed}`)
    console.log()
}