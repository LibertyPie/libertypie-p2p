
var colors = require('colors');

const Factory = artifacts.require("Factory");
const PermissionManager = artifacts.require("../PermissionManager/PermissionManager");
const EthernalStorage = artifacts.require("../Storage/Storage");

const Seeder = require("../seed/Seeder");

module.exports =  (deployer) => {

  

  infoMsg("Deploying Permission Manager");

  //deploy permission manager 
  deployer.deploy(PermissionManager).then((_pmDeployed)=>{

      let _pmAddress = _pmDeployed.address;

      successMsg(`Permission Manager Address ${_pmAddress}`)

      infoMsg(`Deploying Eternal Storage Core`)

      //deploy storage 
      //eternal storage takes permission manager contract address as an argument
      return deployer.deploy(EthernalStorage, _pmAddress).then((_storageDeployed)=>{ 

          successMsg(`Eternal Storage Address ${_storageDeployed.address}`)
          
          infoMsg(`Deploying Factory Contract`)

          //finally lets install contract factory 
          return deployer.deploy(Factory, _pmAddress, _storageDeployed.address).then(async (_fInstance)=>{  

              successMsg(`Facory Deployed Successfully, Address: ${_fInstance.address}`);

              

              try{
                
                infoMsg(`Permitting Factory (Main) contract (${_fInstance.address}) as permitted storage editor (STORAGE_EDITOR)`)

                let permResult = await _pmDeployed.grantRole("STORAGE_EDITOR",_fInstance.address);

                successMsg(`Contract ${_fInstance.address} now permitte on Storage: ${permResult.tx}`)

                infoMsg(`Seeding data into Factory Config contract `)

                
              } catch(e){

                 errorMsg(`Seeding Data for Factory (Main) contract Error: ${e.message}`)
                 console.error(e)
              }
                        
          }); //end deploy factory

      }); //end storage deployer

  });// end deploy permission manager

};


