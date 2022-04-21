const { expect } = require("chai");
const { ethers } = require("hardhat");

let dataFactory;
let dataContract;
let factories;
let args;
let contracts;
let address;
let buildings = [
  {
    area: 0,
    location: 2,
  },
  {
    area: 0,
    location: 1,
  }
];
let npcs = [
  {
    area: 0,
    level: 2
  }
];
let enemies = [
  {
    area: 0,
    level: 2,
    species: 1
  },
  {
    area: 0,
    level: 2,
    species: 1
  },
  {
    area: 0,
    level: 2,
    species: 1
  },
  {
    area: 0,
    level: 2,
    species: 1
  },
  {
    area: 0,
    level: 2,
    species: 1
  }
];
let equipment = [
  // VALUE IS IRRELEVANT
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
]

async function getAccounts() {
  const accounts = await hre.ethers.getSigners();
  address = accounts[0].address;
}

async function deploy() {
  dataFactory = await hre.ethers.getContractFactory("ERC42069Data");
  dataContract = await dataFactory.deploy();
  await dataContract.deployed();
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
  ];
  args = [
    ["Pixel Credits", "CREDITS", dataContract.address],
    ["Pixel Asset", "PIXEL", dataContract.address],
    [dataContract.address],
    [dataContract.address],
    [dataContract.address],
    [dataContract.address],
    [dataContract.address],
    [dataContract.address],
    [dataContract.address]
  ];
  contracts = [
    await factories[0].deploy(...args[0]),
    await factories[1].deploy(...args[1]),
    await factories[2].deploy(...args[2]),
    await factories[3].deploy(...args[3]),
    await factories[4].deploy(...args[4]),
    await factories[5].deploy(...args[5]),
    await factories[6].deploy(...args[6]),
    await factories[7].deploy(...args[7]),
    await factories[8].deploy(...args[8])
  ];
}

async function setup() {
  await setGameSettings();
  await setConsumableType();
  await setAddresses();
  await setWorld();
}

async function setAddresses() {
  console.log("ERC42069DATA", dataContract.address);
  console.log("ERC20CREDITS", contracts[0].address);
  console.log("ERC42069", contracts[1].address);
  console.log("ERC42069HELPER", contracts[2].address);
  console.log("ERC42069REVERTS", contracts[3].address);
  console.log("GAMEMASTER", contracts[4].address);
  console.log("GREATFILTER", contracts[5].address);
  console.log("EXPANSION0MASTER", contracts[6].address);
  console.log("ERC42069DATAHELPER", contracts[7].address);
  console.log("NAMEGENERATOR", contracts[8].address);
  await dataContract.setAA("ERC20CREDITS", contracts[0].address);
  await dataContract.setAA("ERC42069", contracts[1].address);
  await dataContract.setAA("ERC42069HELPER", contracts[2].address);
  await dataContract.setAA("ERC42069REVERTS", contracts[3].address);
  await dataContract.setAA("GAMEMASTER", contracts[4].address);
  await dataContract.setAA("GREATFILTER", contracts[5].address);
  await dataContract.setAA("EXPANSION0MASTER", contracts[6].address);
  await dataContract.setAA("ERC42069DATAHELPER", contracts[7].address);
  await dataContract.setAA("NAMEGENERATOR", contracts[8].address);
}

async function setGameSettings() {
  await dataContract.setGS("MAXTOTALLEVEL", 99);
  await dataContract.setGS("MAXTOTALHEALTH", 1000000);
  await dataContract.setGS("MAXTOTALENERGY", 5000);
  await dataContract.setGS("MAXTOTALSTATS", 1000);
  await dataContract.setGS("MAXITEMSLOTS", 9);
  await dataContract.setGS("MAXITEMHEALTH", 100);
  await dataContract.setGS("MAXITEMENERGY", 100);
  await dataContract.setGS("MAXITEMSTATS", 20);
  await dataContract.setGS("STARTINGHEALTH", 100);
  await dataContract.setGS("STARTINGENERGY", 100);
  await dataContract.setGS("STARTINGSTATS", 10);
  await dataContract.setGS("MAXLEVELSTATS", 3);
  await dataContract.setGS("BREEDINGRESET", 3600);
  await dataContract.setGS("FIGHTEARNING", 10);
  await dataContract.setGS("FIGHTEXPERIENCE", 20);
  await dataContract.setGS("LEVELUP", 1000);
  await dataContract.setGS("MAXPRODUCTION", 20);
  await dataContract.setGS("PRODUCTIONRESET", 600);
  await dataContract.setGS("CHARACTERCOST", 100);
  await dataContract.setGS("EQUIPPABLECOST", 500);
  await dataContract.setGS("PRODUCTIONCOST", 2500);
  await dataContract.setGS("BUILDINGCOST", 10000);
  await dataContract.setGS("EXPANDBUILDINGCOST", 5000);
  await dataContract.setGS("CITYBLOCKROWSIZE", 16);
  await dataContract.setGS("AREASIZE", (16 * 16));
  await dataContract.setGS("MAXAREAS", 4096);
}

async function setConsumableType() {
    await dataContract.setGD("CONSUMABLETYPE", 0, "HEALTHRESTORE", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 1, "ENERGYRESTORE", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 2, "STRENGTHBOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 3, "DEXTERITYBOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 4, "INTELLIGENCEBOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 5, "CHARISMABOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 6, "HEALTHBOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 7, "ENERGYBOOST", 1, "SETUP");
    await dataContract.setGD("CONSUMABLETYPE", 8, "ENERGYBOOST", 1, "SETUP");
}

async function setWorld() {
  await setFreeCharacters();
  await setNPCs();
  await setEnemies();
  await setBuildings();
  await setFreeItems();
}

async function setFreeCharacters() {
  await contracts[4].generateCharacter(1, 0, 0, 0, address);
}

async function setFreeItems() {
  for (let index = 0; index < equipment.length; index++) {
    await contracts[4].generateEquippable(2, 0, 1);
    await contracts[4].generateEquippable(2, 1, 1);
    await contracts[4].generateEquippable(2, 2, 1);
    await contracts[4].generateEquippable(2, 3, 1);
    await contracts[4].generateEquippable(2, 4, 1);
    await contracts[4].generateEquippable(2, 5, 1);
    await contracts[4].generateEquippable(2, 6, 1);
    await contracts[4].generateEquippable(2, 7, 1);
    await contracts[4].generateEquippable(2, 8, 1);
  }
}

async function setBuildings() {
  for (let index = 0; index < buildings.length; index++) {
    await contracts[4].generateBuilding(buildings[index].area, buildings[index].location, 1);
  }
}

async function setNPCs() {
  for (let index = 0; index < npcs.length; index++) {
    await contracts[4].generateCharacter(npcs[index].level, 0, 1, npcs[index].area, "0x000000000000000000000000000000000000dEaD");
  }
}

async function setEnemies() {
  for (let index = 0; index < enemies.length; index++) {
    await contracts[4].generateCharacter(enemies[index].level, enemies[index].species, 2, enemies[index].area, "0x000000000000000000000000000000000000dEaD");
  }
}
async function setupGame() {
  await deploy();
  await getAccounts();
  await setup();
}
describe("PixelRPG", async function () {
  it("Should set up all contracts and variables", async function () {
    await setupGame().then(async(data) => {
      
    });
  });
  it("Should equip item #16 in item slot #6 to NFT #1", async function () {
    console.log(await dataContract.getGD("GENERAL", 16, "DNA"));
    console.log(await dataContract.getGD("GENERAL", 17, "DNA"));
    let equipTX = await contracts[5].equip(6, 16, 1);
    equipTX.wait();
  });
});
