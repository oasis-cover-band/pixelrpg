// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let factories;
let contracts;

async function getAccounts() {
  const accounts = await hre.ethers.getSigners();
  address = accounts[1].address;
}

async function deploy() {
  factories = [
    await hre.ethers.getContractFactory("ERC20Credits"),
    await hre.ethers.getContractFactory("ERC42069"),
    await hre.ethers.getContractFactory("ERC42069Helper"),
    await hre.ethers.getContractFactory("ERC42069Reverts"),
    await hre.ethers.getContractFactory("GameMaster"),
    await hre.ethers.getContractFactory("GreatFilter"),
    await hre.ethers.getContractFactory("Expansion0Master"),
    await hre.ethers.getContractFactory("ERC42069DataHelper"),
    await hre.ethers.getContractFactory("NameGenerator"),
    await hre.ethers.getContractFactory("MintMaster")
  ];
  contracts = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    await factories[9].attach("0x610178dA211FEF7D417bC0e6FeD39F05609AD788")
  ];
}

async function setArea(area) {
  for(let index = 0; index < 20; index++) {
    await contracts[9].setArea(area, index);
  }
}
async function setEnemies(area) {
  for(let index = 0; index < 20; index++) {
    await contracts[9].setEnemies(area);
  }
}
async function setNPCs(area) {
  for(let index = 0; index < 5; index++) {
    await contracts[9].setNPCs(area);
  }
}

async function main() {
  await deploy();
  await getAccounts();
  await setArea(0);
  await setEnemies(0);
  await setNPCs(0);
  for(let area = 0; area < 4; area++) {
    setTimeout(async () => {
      await setArea(area);
      await setEnemies(area);
      await setNPCs(area);
    }, area * 10000);
  }
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    // process.exit(1); // keep running the script!
  });
  