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
  await setFreeConsumables();
  await setFreeProducables();
  await setFreeItems();
}
async function setFreeItems() {
  await contracts[9].generateEquippable(2, 0, 1);
  await contracts[9].generateEquippable(2, 1, 1);
  await contracts[9].generateEquippable(2, 2, 1);
  await contracts[9].generateEquippable(2, 3, 1);
  await contracts[9].generateEquippable(2, 4, 1);
  await contracts[9].generateEquippable(2, 5, 1);
  await contracts[9].generateEquippable(2, 6, 1);
  await contracts[9].generateEquippable(2, 7, 1);
  await contracts[9].generateEquippable(2, 8, 1);
}

async function setFreeProducables() {
  await contracts[9].generateProducable(1, 0, 1);
  await contracts[9].generateProducable(1, 1, 1);
  await contracts[9].generateProducable(1, 2, 1);
  await contracts[9].generateProducable(1, 3, 1);
  await contracts[9].generateProducable(1, 4, 1);
  await contracts[9].generateProducable(1, 5, 1);
  await contracts[9].generateProducable(1, 6, 1);
  await contracts[9].generateProducable(1, 7, 1);
  await contracts[9].generateProducable(1, 8, 1);
}


async function setFreeConsumables() {
  await contracts[9].generateConsumable(200, 0, 1);
  await contracts[9].generateConsumable(200, 1, 1);
  await contracts[9].generateConsumable(200, 2, 1);
  await contracts[9].generateConsumable(200, 3, 1);
  await contracts[9].generateConsumable(200, 4, 1);
  await contracts[9].generateConsumable(200, 5, 1);
  await contracts[9].generateConsumable(200, 6, 1);
  await contracts[9].generateConsumable(200, 7, 1);
  await contracts[9].generateConsumable(200, 8, 1);
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
  