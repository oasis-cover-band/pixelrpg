require("@nomiclabs/hardhat-waffle");
const ALCHEMY_API_KEY = "EBbF5DnGDkdIJWap_6Lv0caEs3sEv1DW";
const ROPSTEN_PRIVATE_KEY = "8b6eb9d66a80167dbc9da5aea5bc7edfccba07df89521c90ccdae6e77396fed6";

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
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`]
    }
  }
};
