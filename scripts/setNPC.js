// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let factories;
let contracts;

let baseNonce = 0;
let nonceOffset = 120;
let accounts;
function getNonce() {
nonceOffset++;
return baseNonce + nonceOffset;
}
async function getAccounts() {
  accounts = await hre.ethers.getSigners();
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
  // await contracts[9].setArea(area, 0, 1, 1, 1, {gasLimit: Math.floor(8429212 * 1.25)});
  // await contracts[9].setArea(area, 3, 1, 1, 2, {gasLimit: Math.floor(8429212 * 1.25)});
  // await contracts[9].setArea(area, 15, 1, 1, 3, {gasLimit: Math.floor(8429212 * 1.25)});
  // await contracts[9].setArea(area, 18, 1, 1, 4, {gasLimit: Math.floor(8429212 * 1.25)});
}
  

async function setEnemies(area) {
    if (area === 0) {
      await contracts[9].setEnemies(area, 1, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 2, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 3, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 1, 1, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 2, 1, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 3, 1, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 1, 2, {gasLimit: Math.floor(5429212 * 1.25)});
      await contracts[9].setEnemies(area, 2, 2, {gasLimit: Math.floor(5429212 * 1.25)});
    } else if (area < 2056) {
      await contracts[9].setEnemies(area, 1, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      if (area % 4 === 0) {
      await contracts[9].setEnemies(area, 1, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
      if (area % 8 === 0) {
        await contracts[9].setEnemies(area, 1, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
    } else if (area < (2056+1028)) {
      await contracts[9].setEnemies(area, 2, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      if (area % 4 === 0) {
      await contracts[9].setEnemies(area, 2, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
      if (area % 8 === 0) {
        await contracts[9].setEnemies(area, 2, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
    } else {
      await contracts[9].setEnemies(area, 3, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      if (area % 4 === 0) {
        await contracts[9].setEnemies(area, 3, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
      if (area % 8 === 0) {
        await contracts[9].setEnemies(area, 3, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
      if (area % 16 === 0) {
        await contracts[9].setEnemies(area, 3, 0, {gasLimit: Math.floor(5429212 * 1.25)});
      }
    }
}
async function setGuards(area) {
    if (area % 8 === 0) {
      await contracts[9].setNPCs(area, 3, {gasLimit: Math.floor(5429212 * 1.25)});
      if (area % 16 === 0) {
        await contracts[9].setNPCs(area, 3, {gasLimit: Math.floor(5429212 * 1.25)});
      }
    }
    if (area % 32 === 0) {
      await contracts[9].setNPCs(area, 4, {gasLimit: Math.floor(5429212 * 1.25)});
      if (area > 2056) {
        await contracts[9].setNPCs(area, 4, {gasLimit: Math.floor(5429212 * 1.25)});
      }
    }
    if (area % 64 === 0) {
      await contracts[9].setNPCs(area, 5, {gasLimit: Math.floor(5429212 * 1.25)});
    }
}
async function setNPCs(area) {
  if (area % 4 === 0) {
    const nonce =  getNonce();
    await contracts[9].setNPCs(area, 1, {gasLimit: Math.floor(5429212 * 1.25)});
  }
}

areas = [0, 1, 2, 3, 64, 4096, 4092, 4032, 4033, 4034];

async function main() {
  await deploy();
  await getAccounts();
  
  // console.log(await accounts[0].estimateGas(await contracts[9].setNPCs(0, 2, {})));
  for(let index = 0; index < 4096; index++) {
    await setAreaFull(index);
    // areas.splice(index);
    // console.log(accounts[0]);
  }
}

async function setAreaFull(area) {
  await setGuards(area).then(async after => {
      await setNPCs(area);
  });
}

main()
  .then(() => {
    if (areas.length === 0) {
      process.exit(0);
    }
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
  