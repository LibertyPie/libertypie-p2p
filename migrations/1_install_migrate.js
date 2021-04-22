
var colors = require('colors');

const Factory = artifacts.require("Factory");
const PermissionManager = artifacts.require("../PermissionManager/PermissionManager");
const EthernalStorage = artifacts.require("../Storage/Storage");
const Utils = require("../classes/Utils");

//const Seeder = require("../seed/Seeder");

module.exports =  (deployer) => {

  

  Utils.infoMsg("Deploying Permission Manager");

  //deploy permission manager 
  deployer.deploy(PermissionManager).then((_pmDeployed)=>{

      let _pmAddress = _pmDeployed.address;

      Utils.successMsg(`Permission Manager Address ${_pmAddress}`)

      Utils.infoMsg(`Deploying Eternal Storage Core`)

      //deploy storage 
      //eternal storage takes permission manager contract address as an argument
      return deployer.deploy(EthernalStorage, _pmAddress).then((_storageDeployed)=>{ 

          Utils.successMsg(`Eternal Storage Address ${_storageDeployed.address}`)
          
          Utils.infoMsg(`Deploying Factory Contract`)

          //finally lets install contract factory 
          return deployer.deploy(Factory, _pmAddress, _storageDeployed.address).then(async (_fInstance)=>{  

              Utils.successMsg(`Facory Deployed Successfully, Address: ${_fInstance.address}`);

            
              try{
                
                Utils.infoMsg(`Permitting Factory (Main) contract (${_fInstance.address}) as permitted storage editor (STORAGE_EDITOR)`)

                let permResult = await _pmDeployed.grantRole("STORAGE_EDITOR",_fInstance.address);

                Utils.successMsg(`Contract ${_fInstance.address} now permitte on Storage: ${permResult.tx}`)
                
              } catch(e){

                 Utils.errorMsg(` Factory (Main) contract Error: ${e.message}`)
                 console.error(e)
              }
                        
          }); //end deploy factory

      }); //end storage deployer

  });// end deploy permission manager

};


