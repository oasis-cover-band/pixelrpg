// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

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
  },
  {
    area: 0,
    location: 3,
  },
  {
    area: 0,
    location: 4,
  },
  {
    area: 0,
    location: 5,
  },
  {
    area: 0,
    location: 6,
  },
  {
    area: 0,
    location: 7,
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
  0
]

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

async function setup() {
  await setEnemies();
  await setFreeRoamingCharacters();
  await setNPCs();
}


async function setFreeRoamingCharacters() {
  const index = 1;
    await contracts[9].generateEquippedCharacter(1 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(5 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(3 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(2 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(1 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(5 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(3 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(2 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(1 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(5 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(3 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(2 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(1 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(5 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(3 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(2 * index, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateEquippedCharacter(59, 0, 0, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(2 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(3 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(4 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(5 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(6 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(7 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(2 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(3 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(4 * (index % 14) + 1, 2, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(5 * (index % 14) + 1, 2, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(6 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(7 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(2 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(3 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(4 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(5 * (index % 14) + 1, 2, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(6 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(7 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(2 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(3 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(4 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(5 * (index % 14) + 1, 0, 2, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(6 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
    await contracts[9].generateCharacter(7 * (index % 14) + 1, 1, 1, index, "0x000000000000000000000000000000000000dEaD");
}

async function setNPCs() {
  for (let index = 0; index < npcs.length; index++) {
    await contracts[9].generateCharacter(npcs[index].level, 0, 1, npcs[index].area, "0x000000000000000000000000000000000000dEaD");
  }
}

async function setEnemies() {
  for (let index = 0; index < enemies.length; index++) {
    await contracts[9].generateCharacter(enemies[index].level, enemies[index].species, 2, enemies[index].area, "0x000000000000000000000000000000000000dEaD");
  }
}

async function main() {
  await deploy();
  await getAccounts();
  await setup();
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    // process.exit(1); // keep running the script!
  });
  