// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let factories;
let contracts;

let baseNonce = 0;
let nonceOffset = 164;
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
    await hre.ethers.getContractFactory("ERC42069Data"),
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
    await factories[0].attach("0x763B0FAE0d61550dC8966DE515E356821FF69108")
  ];
}

async function getArea(area) {
  for(let index = 0; index < 20; index++) {
    console.log(area, index);
    console.log(await contracts[9].getGD("WORLD", area, index.toString()));
  }
}
areas = [0];

async function main() {
  await getAccounts();
  await deploy();
  for (let index = 0; index < this.areas.length; index++) {
    await getAreaFull(this.areas[index]);
    this.areas.pop();
  }
}

async function getAreaFull(area) {
  await getArea(area);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    // process.exit(1); // keep running the script!
    main();
  });
  