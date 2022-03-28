//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC42069DataI {

    function getGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) external view returns (uint256);

    function getGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) external view returns (string memory);
    
    function n2s(uint _i) external pure returns (string memory);
}

contract ERC42069DataHelper {
    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function getCharacterConsumablesInfo0(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("INVENTORY", _NFTID, "0"),
            getGD("INVENTORY", _NFTID, "1"),
            getGD("INVENTORY", _NFTID, "2"),
            getGD("INVENTORY", _NFTID, "3"),
            getGD("INVENTORY", _NFTID, "4"),
            getGD("INVENTORY", _NFTID, "5"),
            getGD("INVENTORY", _NFTID, "6")
        );
    }

    function getCharacterConsumablesInfo1(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("INVENTORY", _NFTID, "7"),
            getGD("INVENTORY", _NFTID, "8"),
            getGD("INVENTORY", _NFTID, "9"),
            getGD("INVENTORY", _NFTID, "10"),
            getGD("INVENTORY", _NFTID, "11"),
            getGD("INVENTORY", _NFTID, "12"),
            getGD("INVENTORY", _NFTID, "13")
        );
    }

    function getCharacterStats(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "LEVEL"),
            getGD("CHARACTER", _NFTID, "EXPERIENCE"),
            getGD("CHARACTER", _NFTID, "SPECIES"),
            getGD("CHARACTER", _NFTID, "STRENGTH"),
            getGD("CHARACTER", _NFTID, "DEXTERITY"),
            getGD("CHARACTER", _NFTID, "INTELLIGENCE"),
            getGD("CHARACTER", _NFTID, "CHARISMA")
        );
    }

    function getCharacterInfo(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "MERGED"),
            getGD("CHARACTER", _NFTID, "EVOLUTION"),
            getGD("CHARACTER", _NFTID, "STATE"),
            getGD("GENERAL", _NFTID, "DNA"),
            getGD("GENERAL", _NFTID, "TYPE"),
            getGD("COMPANION", _NFTID, "0"),
            getGD("GENERAL", _NFTID, "SPECIAL")
        );
    }

    function getCharacterVitality(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, string memory, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "HEALTH"),
            getGD("CHARACTER", _NFTID, "MAXHEALTH"),
            getGD("CHARACTER", _NFTID, "ENERGY"),
            getGD("CHARACTER", _NFTID, "MAXENERGY"),
            getGD("CHARACTER", _NFTID, "FREESTATS"),
            getGDN("GENERAL", _NFTID, "NAME"),
            getGD("CHARACTER", _NFTID, "NEXTBREEDING")
        );
    }

    function getCharacterEquipped0(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "0"),
            getGD("CHARACTER", _NFTID, "1"),
            getGD("CHARACTER", _NFTID, "2"),
            getGD("CHARACTER", _NFTID, "3"),
            getGD("CHARACTER", _NFTID, "4"),
            getGD("CHARACTER", _NFTID, "5"),
            getGD("CHARACTER", _NFTID, "6")
        );
    }

    function getCharacterEquipped1(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "7"),
            getGD("CHARACTER", _NFTID, "8"),
            getGD("CHARACTER", _NFTID, "9"),
            getGD("CHARACTER", _NFTID, "10"),
            getGD("CHARACTER", _NFTID, "11"),
            getGD("CHARACTER", _NFTID, "12"),
            getGD("CHARACTER", _NFTID, "13")
        );
    }

    function getCharacterAttacks0(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "42069"),
            getGD("CHARACTER", _NFTID, "42070"),
            getGD("CHARACTER", _NFTID, "42071"),
            getGD("CHARACTER", _NFTID, "42072"),
            getGD("CHARACTER", _NFTID, "42073"),
            getGD("CHARACTER", _NFTID, "42074"),
            getGD("CHARACTER", _NFTID, "42075")
        );
    }

    function getCharacterAttacks1(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("CHARACTER", _NFTID, "42076"),
            getGD("CHARACTER", _NFTID, "42077"),
            getGD("CHARACTER", _NFTID, "42078"),
            getGD("CHARACTER", _NFTID, "42079"),
            getGD("CHARACTER", _NFTID, "42080"),
            getGD("CHARACTER", _NFTID, "42081"),
            getGD("CHARACTER", _NFTID, "42082")
        );
    }

    function getProducableInfo(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("PRODUCABLE", _NFTID, "PRODUCES"),
            getGD("PRODUCABLE", _NFTID, "PRODUCTION"),
            getGD("PRODUCABLE", _NFTID, "NEXTPRODUCTION"),
            getGD("PRODUCABLE", _NFTID, "PLACEDIN"),
            getGD("GENERAL", _NFTID, "DNA"),
            getGD("GENERAL", _NFTID, "TYPE")
        );
    }

    function getBuildingInfo(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("BUILDING", _NFTID, "SIZE"),
            getGD("BUILDING", _NFTID, "STORIES"),
            getGD("BUILDING", _NFTID, "LOCATION"),
            getGD("GENERAL", _NFTID, "DNA"),
            getGD("GENERAL", _NFTID, "TYPE"),
            getGD("GENERAL", _NFTID, "AREA")
        );
    }

    function getConsumableInfo(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256) {
        return (
            getGD("CONSUMABLE", _NFTID, "TYPE"),
            getGD("CONSUMABLE", _NFTID, "AMOUNT"),
            getGD("GENERAL", _NFTID, "DNA"),
            getGD("GENERAL", _NFTID, "TYPE")
        );
    }

    function getEquippableInfo(
        uint256 _NFTID
    ) external view returns (uint256, uint256) {
        return (
            getGD("GENERAL", _NFTID, "DNA"),
            getGD("GENERAL", _NFTID, "TYPE")
        );
    }

    function getEquippableStats(
        uint256 _NFTID
    ) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("EQUIPPABLE", _NFTID, "HEALTHBOOST"),
            getGD("EQUIPPABLE", _NFTID, "ENERGYBOOST"),
            getGD("EQUIPPABLE", _NFTID, "STRENGTHBOOST"),
            getGD("EQUIPPABLE", _NFTID, "DEXTERITYBOOST"),
            getGD("EQUIPPABLE", _NFTID, "INTELLIGENCEBOOST"),
            getGD("EQUIPPABLE", _NFTID, "CHARISMABOOST"),
            getGD("EQUIPPABLE", _NFTID, "EQUIPSLOT")
        );
    }

    function getAreaInfo(
        uint256 _areaID,
        uint256 _indiceStart
    ) external view returns (uint256, uint256, uint256, uint256, uint256) {
        return (
            getGD("WORLD", _areaID, d.n2s(_indiceStart)),
            getGD("WORLD", _areaID, d.n2s(_indiceStart + 1)),
            getGD("WORLD", _areaID, d.n2s(_indiceStart + 2)),
            getGD("WORLD", _areaID, d.n2s(_indiceStart + 3)),
            getGD("WORLD", _areaID, d.n2s(_indiceStart + 4))
        );
    }

    function getGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) internal view returns (uint256) {
        return d.getGD(_symbol, _NFTID, _statName);
    }

    function getGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) internal view returns (string memory) {
        return d.getGDN(_symbol, _NFTID, _statName);
    }
}
// aa (ACTIONABLE ADDRESSES)
    // SHORTHAND NAME -> EVM ADDRESS
    // TREASURY -
    // WHERE DEV'S CUT GOES.
    // 
    // OWNER -
    // OWNER OF ALL CONTRACTS AKA DUNGEON MASTER.
    //
    // ERC42069 -
    // BASE CONTRACT FOR CHARACTERS, ITEMS, BUILDINGS.
    //
    // DATA - AKA ERC42069DATA
    // MAIN INFORMATION HUB FOR ALL CONTRACTS.
    //
    // GAMEMASTER -
    // ENCOMPASSES CALLS AND ACTIONS FROM ALL CONTRACTS,
    // ONLY HAS BASE REQUIRES/REVERTS FOR FUNCTIONALITY OF GAME.
    // OVERWATCH -
    // WHAT A USER CAN CALL - ONLY CALLS FUNCTIONS FROM
    // GAME MASTER. THIS CONTAINS MAJOR REQUIRES/REVERTS
    // IN RESPECT TOWARDS OWNERSHIP OF AN NFT, ITEM, OR OTHERWISE.
    //

// gd (GAME DATA)
    // SYMBOL OF NFT -> NFTID -> STATISTIC NAME = VALUE OF STATISTIC

    // 
    //  ** IMPORTANT STAT START **
    // ***************************************
    // IF SYMBOL OF NFT == GENERAL, **TYPE** DICTATES
    // WHAT KIND OF ERC42069 THIS IS
    // AND APPLIES TO ALL NFTS
    // 
    // "GENERAL"-> NFTID -> **TYPE** =
    // 0 == METABEING AKA CHARACTER/MONSTER/NPC
    // 1 == 
    // 2 == CONSUMABLE ITEM
    // 3 == EQUIPPABLE ITEM
    // 4 == PRODUCABLE ITEM
    // 5 == BUILDING ITEM
    // CONSUMABLE ITEMS ARE ERC20
    // ***************************************
    //  ** IMPORTANT STAT END **






    // 
    //  ** IMPORTANT STAT START **
    // ***************************************
    // **SPECIAL** DICTATES THE NFTS ACTIVE
    // ROLE IN THE WORLD - LISTED BELOW
    // ONLY APPLIED TO **TYPE** 0
    // 
    // "GENERAL"-> NFTID -> **SPECIAL** =
    // 0 == REGULAR CHARACTER OR BUILDING OR ITEM
    // 1 == NPC
    // 2 == ENEMY
    // ***************************************
    //  ** IMPORTANT STAT END **






    // 
    //  ** IMPORTANT STAT START **
    // ***************************************
    // **AREA** DICTATES WHICH AREA THE NFT
    // IS IN THE "WORLD".
    // 
    // ONLY APPLIES TO **TYPE** 0, **TYPE** 5
    // 
    // "GENERAL"-> NFTID -> **AREA** =
    // AREA IN THE WORLD
    // ***************************************
    //  ** IMPORTANT STAT END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **GENERAL** DICTATES A USERS GENERAL.
    // 
    // APPLIES TO ALL TYPES
    // 
    // **GENERAL** -> NFTID -> STATNAME =
    // DNA (ALL TYPES)
    // TYPE (ALL TYPES)
    // SPECIAL (ONLY TYPE 0)
    // AREA (ONLY TYPE 0 + TYPE 5)
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **CHARACTER** DICTATES A NFT CHARACTER.
    // 
    // ONLY APPLIES TO **TYPE** 0
    // 
    // **CHARACTER** -> NFTID -> STATNAME =
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **EQUIPPABLE** DICTATES A NFT EQUIPPABLE.
    // 
    // ONLY APPLIES TO **TYPE** 3
    // 
    // **EQUIPPABLE** -> NFTID -> STATNAME =
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **PRODUCABLE** DICTATES A NFT PRODUCABLE.
    // 
    // ONLY APPLIES TO **TYPE** 4
    // 
    // **PRODUCABLE** -> NFTID -> STATNAME =
    // PRODUCES
    // PRODUCTION
    // NEXTPRODUCTION
    // PLACEDIN (WHICH NFTID OF TYPE 5 IS THIS PLACED IN)
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **INVENTORY** DICTATES A NFT INVENTORY.
    // 
    // ONLY APPLIES TO **TYPE** 0
    // 
    // **INVENTORY** -> NFTID -> PRODUCABLETYPE[UINTFORCEDINTOSTRING] IE "0", "1" = BALANCE OF PRODUCABLETYPE
    // INVENTORIES ARE SPECIAL AND KEEP TRACK OF
    // PRODUCED ITEMS FOR CONSUMPTION + SELLING
    // THEY ARE AS SUCH DESCRIBED ABOVE.
    // 0 == HEALTH REPLENISH POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 1 == ENERGY REPLENISH POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 2 == STRENGTH POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 3 == DEXTERITY POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 4 == INTELLIGENCE POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 5 == CHARISMA POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 6 == HEALTH BOOST POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 7 == ENERGY BOOST POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // 8 == BREED REPLENISH POTION? (SEE: d.GG("CONSUMABLETYPE"))
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **BUILDING** DICTATES A NFT BUILDING'S
    // DETAILS.
    // 
    // ONLY APPLIES TO **TYPE** 5
    // 
    // **BUILDING** -> NFTID -> STATNAME = 
    // SIZE
    // STORIES
    // LOCATION
    // 
    // **BUILDING** -> NFTID -> INTERIOR[UINTFORCEDINTOSTRING] IE "0", "1" = PRODUCABLENFTID
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






    //  ** IMPORTANT IDENTIFIERS START **
    // ***************************************
    // **CONSUMABLETYPE** IS A GENERAL DATA SECTION
    // THAT IS USED TO CONTAIN DATA FROM CONSUMABLETYPE
    // TYPES
    // 
    // 
    // IS A GENERAL DATA SECTIONO
    // 
    // **CONSUMABLETYPE** -> CONSUMABLETYPE -> STATNAME = 
    // HEALTHRESTORE INDEX: 0 / VALUE: 1
    // ENERGYRESTORE INDEX: 1 / VALUE: 1
    // STRENGTHBOOST INDEX: 2 / VALUE: 1
    // DEXTERITYBOOST INDEX: 3 / VALUE: 1
    // INTELLIGENCEBOOST INDEX: 4 / VALUE: 1
    // CHARISMABOOST INDEX: 5 / VALUE: 1
    // HEALTHBOOST INDEX: 6 / VALUE: 1
    // ENERGYBOOST INDEX: 7 / VALUE: 1
    // BREEDINGRESTORE INDEX: 8 / VALUE: 1
    // 
    // 
    // ***************************************
    //  ** IMPORTANT IDENTIFIERS END **






// gs (GAME SETTINGS)
// CHARACTER
// 
    // MAXTOTALLEVEL (CAP OF MAX LEVEL ONE CAN) // 99
    // MAXTOTALHEALTH (CAP OF MAX HEALTH ONE CAN HAVE (MINUS EQUIPPED ITEMS)) // 1000000
    // MAXTOTALENERGY (CAP OF MAX ENERGY ONE CAN HAVE (MINUS EQUIPPED ITEMS)) // 5000
    // MAXTOTALSTATS (CAP OF MAX STATS ONE CAN HAVE (MINUS EQUIPPED ITEMS)) // 1000
    // MAXITEMHEALTH (CAP OF HEALTH AN ITEM CAN GIVE) // 100
    // MAXITEMENERGY (CAP OF ENERGY AN ITEM CAN GIVE) // 100
    // MAXITEMSTATS (CAP OF A SINGLE STAT AN ITEM CAN GIVE) // 20
    // STARTINGHEALTH (CAP OF STARTING HEALTH) // 100
    // STARTINGENERGY (CAP OF STARTING ENERGY) // 100
    // STARTINGSTATS (CAP OF STARTING FREE STATS) // 10
    // MAXLEVELSTATS (CAP OF MAX FREE STATS ON LEVELUP) // 3
    // BREEDINGRESET (TIME A TYPE 0 NEEDS TO WAIT BETWEEN BREEDING) // 3600
// FIGHT
// 
    // FIGHTEARNING (AMOUNT EARNED BY WINNING A FIGHT * ENEMY LEVEL) 50 (ERC20CREDITS)
    // FIGHTEXPERIENCE (EXP EARNED BY WINNING A FIGHT * ENEMY LEVEL) 20 (EXPERIENCE STAT)
    // LEVELUP (EXP NEEDED TO LEVEL UP * LEVEL) 200 (EXPERIENCE STAT)
// PRODUCTION
// 
    // MAXPRODUCTION (MAXIMUM A PRODUCABLE CAN PRODUCE) // 20
    // PRODUCTIONRESET (TIME A TYPE 4 NEEDS TO WAIT BETWEEN BREEDING) // 600 (10 MINS)
// COSTS
// 
    // EQUIPPABLECOST (COST TO GENERATE A RANDOM NFT ITEM (TYPE 3)) 500 (ERC20CREDITS)
    // PRODUCTIONCOST (COST TO GENERATE A RANDOM NFT ITEM (TYPE 4)) 500 (ERC20CREDITS)
    // BUILDINGCOST (COST TO BUILD A BUILDING NFT ITEM (TYPE 5)) 2000 (ERC20CREDITS)
    // EXPANDBUILDINGCOST (COST TO BUILD A BUILDING NFT ITEM (TYPE 5)) 2000 (ERC20CREDITS)
// WORLD
// 
    // AREABLOCKSIZE (AMOUNT OF PLOTS OF LAND IN AN AREA) // 16 
    // AREASIZE (AMOUNT OF PLOTS OF LAND IN AN AREA) // 256 
    // MAXAREAS (AMOUNT OF AREAS IN THE WORLD) // 4096