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
  await setFreeCharacters();
}

async function setFreeCharacters() {
  const address = "0xbcd4042de499d14e55001ccbb24a551f3b954096";
  await contracts[9].generateEquippedCharacter(0, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateCharacter(1, 2, 0, 0, address);
  await contracts[9].generateCharacter(1, 2, 0, 0, address);
  await contracts[9].generateCharacter(1, 2, 0, 0, address);
  await contracts[9].generateCharacter(1, 2, 0, 0, address);
  await contracts[9].generateCharacter(33, 2, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateCharacter(33, 2, 0, 0, address);
  await contracts[9].generateCharacter(33, 1, 0, 0, address);
  await contracts[9].generateCharacter(66, 1, 0, 0, address);
  await contracts[9].generateCharacter(34, 1, 0, 0, address);
  await contracts[9].generateCharacter(70, 1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
  await contracts[9].generateEquippedCharacter(1, 0, 0, address);
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
  