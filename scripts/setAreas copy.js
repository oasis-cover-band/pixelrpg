// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let factories;
let contracts;

let baseNonce = 0;
let nonceOffset = 179;
function getNonce() {
nonceOffset++;
return baseNonce + nonceOffset;
}
async function getAccounts() {
  const accounts = await hre.ethers.getSigners();
  address = accounts[0].address;
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
  for(let index = 0; index < 3; index++) {
    console.log(area, index);
    await contracts[9].setArea(area, index, {nonce: getNonce()});
  }
}
async function setEnemies(area) {
  for(let index = 0; index < 20; index++) {
    await contracts[9].setEnemies(area, {nonce: getNonce()});
  }
}
async function setNPCs(area) {
  for(let index = 0; index < 3; index++) {
    await contracts[9].setNPCs(area, {nonce: getNonce()});
  }
}
// areas = [1];
areas = [0, 1, 2, 3, 64, 4096, 4092, 4032, 4033, 4034];

async function main(areas = this.areas) {
  await deploy();
  await getAccounts();
  for (let index = 0; index < this.areas.length; index++) {
    await setAreaFull(this.areas[index]);
    areas.pop();
  }
}

async function setAreaFull(area) {
  await setArea(area);
  await setEnemies(area);
  await setNPCs(area);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    // process.exit(1); // keep running the script!
    // main(this.areas);
  });
  