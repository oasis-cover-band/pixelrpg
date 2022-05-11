require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ganache");
require('hardhat-contract-sizer');
require("hardhat-gas-reporter");

const ROPSTEN_ALCHEMY_URL = "https://eth-ropsten.alchemyapi.io/v2/EBbF5DnGDkdIJWap_6Lv0caEs3sEv1DW";
const RINKEBY_ALCHEMY_URL = "https://eth-rinkeby.alchemyapi.io/v2/e102b787251011f89ebb8901ae93e455a53b26e4b633b3912244b42b72af1089";
const MUMBAI_ALCHEMY_URL = "https://polygon-mumbai.g.alchemy.com/v2/BQ3IwNvNBPUlyt4K2L0TRj0ZjFzgg3ta";
const RINKEBY_INFURA_URL = "https://rinkeby.infura.io/v3/21fc828c47394e7591eb60b4bc807d07";
const PRIVATE_KEY = "6a1c3881731e235c3d17035060a009a12c4912905a79e56508dd87778e5943ea";
const GANACHE_URL = 'http://127.0.0.1:7545';
const TEVM_URL = "https://testnet.telos.net/evm";

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: ROPSTEN_ALCHEMY_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY],
      gasMultiplier: 1.3,
      // gas: 50000000000,
      gasPrice: 10000000000
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [PRIVATE_KEY, PRIVATE_KEY]
    },
    rinkeby: {
      url: RINKEBY_INFURA_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY],
      gas: 50000000000,
      gasPrice: 30000000000
    },
    ganache: {
      url: GANACHE_URL,
      gasLimit: 6000000000,
      defaultBalanceEther: 10,
    },
    tevm: {
      url: TEVM_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY],
      gasLimit: 6000000000,
      defaultBalanceEther: 10,
    },
  }
};
