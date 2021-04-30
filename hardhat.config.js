/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('hardhat-deploy');
require("@nomiclabs/hardhat-solhint");


 //const fs = require('fs');
const {  
  privateKovanTestNet,
  privateBscTestnet, 
  infuraProjectId, 
  privateKeys, 
  mnemonic, 
  apiKey, 
  localDevPrivateKey 
} = require(__dirname+'/.secrets.js');


module.exports = {
  networks: {
    hardhat: {
      accounts: [{privateKey: `0x${localDevPrivateKey}`, balance: "1000"}]
    },

    kovan: {
      url: privateKovanTestNet,
      chainId: 42,
      //gasPrice: 20000000000,
      accounts: [`0x${localDevPrivateKey}`]
    },  
    bsc_testnet: {
      url: privateBscTestnet,
      chainId: 97,
      ///gasPrice: 20000000000,
      accounts: [`0x${localDevPrivateKey}`]
    },    
    
  },
  solidity: {
    version: "0.7.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
