
var colors = require('colors');

const Factory = artifacts.require("Factory");
const PermissionManager = artifacts.require("../PermissionManager/PermissionManager");
const EthernalStorage = artifacts.require("../Storage/Storage");
const Utils = require("../classes/Utils");
const path = require("path")
const fps  = require("fs/promises")
const process = require('process')

//const Seeder = require("../seed/Seeder");

let deployerEnvInfo = {}
let deployedContracts = {}

let deployedDataFile = path.resolve("../deployed.txt");

module.exports =  (deployer, network, accounts) => {

  deployerEnvInfo["info"] = {
    network,
    account: accounts[0]
  }

  Utils.infoMsg("Deploying Permission Manager");

  //deploy permission manager 
  deployer.deploy(PermissionManager).then((_pmDeployed)=>{

      let _pmAddress = _pmDeployed.address;

      Utils.successMsg(`Permission Manager Address ${_pmAddress}`)

      Utils.infoMsg(`Deploying Eternal Storage Core`)

      deployedContracts["PERMISSION_MANAGER"] = _pmAddress;

      //deploy storage 
      //eternal storage takes permission manager contract address as an argument
      return deployer.deploy(EthernalStorage, _pmAddress).then((_storageDeployed)=>{ 

          Utils.successMsg(`Eternal Storage Address ${_storageDeployed.address}`)
          
          Utils.infoMsg(`Deploying Factory Contract`)

          deployedContracts["STORAGE"] = _storageDeployed.address;

          //finally lets install contract factory 
          return deployer.deploy(Factory, _pmAddress, _storageDeployed.address).then(async (_fInstance)=>{  

              Utils.successMsg(`Facory Deployed Successfully, Address: ${_fInstance.address}`);

            
              try{
                
                Utils.infoMsg(`Permitting Factory (Main) contract (${_fInstance.address}) as permitted storage editor (STORAGE_EDITOR)`)

                let permResult = await _pmDeployed.grantRole("STORAGE_EDITOR",_fInstance.address);

                Utils.successMsg(`Contract ${_fInstance.address} now permitte on Storage: ${permResult.tx}`)

                deployedContracts["FACTORY"] = _fInstance.address;

                deployedContracts["env"] = deployerEnvInfo;

                let deployedDataObj = JSON.stringify({
                    env: deployerEnvInfo,
                    contracts: deployedContracts
                }, null, 2)

                await fps.writeFile(deployedDataFile, deployedDataObj);

              } catch(e){

                 Utils.errorMsg(` Factory (Main) contract Error: ${e.message}`)
                 console.error(e)
              }

              //process.exit();

          }); //end deploy factory

      }); //end storage deployer

  });// end deploy permission manager

};


