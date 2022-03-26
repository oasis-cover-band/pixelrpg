//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error InvalidDataSender(address _target, address _sender);

contract ERC42069Data {

    mapping(string => address) public aa; // ACTIONABLE ADDRESSES
    mapping(string => mapping(uint256 => mapping(string => uint256))) gd; // GAME DATA
    mapping(string => mapping(uint256 => mapping(string => string))) gdn; // GAME DATA
    mapping(string => uint256) gs; // GAME SETTINGS
    uint256 setup;
    uint256 private seed;
    constructor() {
        aa["OWNER"] = msg.sender;
        aa["SETUP"] = msg.sender;
        setup = 1;
        seed = 42069;
    }

    function finishSetup() internal {
        addressCheck(aa["SETUP"], msg.sender);
        setup = 0;
        aa["SETUP"] = address(0);
    }

    function setGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue,
        string memory _msgSender
    ) external {
        addressCheck(aa[_msgSender], msg.sender);
        messWithSeed();
        gd[_symbol][_NFTID][_statName] = _statValue;
    }

    function setGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue,
        string memory _msgSender
    ) external {
        addressCheck(aa[_msgSender], msg.sender);
        gdn[_symbol][_NFTID][_statName] = _statValue;
    }

    function messWithSeed() internal {
        if (seed + (r() % 8008135) > 2**69 - 1) {
            seed = 42069 + (r() / 40);
        } else {
            seed = seed + (r() % 8008135);
        }
    }

    function getGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) external view returns (uint256) {

        return gd[_symbol][_NFTID][_statName];
    }

    function getGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) external view returns (string memory) {

        return gdn[_symbol][_NFTID][_statName];
    }

    function setGS(
        string memory _setting,
        uint256 _settingValue
    ) external {
        addressCheck(aa["OWNER"], msg.sender);
        
        gs[_setting] = _settingValue;
    }

    function getGS(
        string memory _setting
        ) external view returns (uint256) {

        return gs[_setting];
    }

    function setAA(
        string memory _name,
        address _address
    ) external {
        addressCheck(aa["OWNER"], msg.sender);
        aa[_name] = _address;
        if (setup == 0) {
            aa["SETUP"] = address(0);
        }
    }

    function getAA(
        string memory _name
    ) external view returns (address) {
        return aa[_name];
    }
    function r() public view returns (uint256) {
        return 40 + (uint(keccak256(abi.encodePacked(seed, block.timestamp))) / 2);
    }
    function n2s(
        uint _i
    ) public pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    function addressCheck(
        address _target,
        address _sender
    ) internal pure {
        if (_target != _sender) {
            revert InvalidDataSender({
                _target: _target,
                _sender: _sender
            });
        }
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
    // AREABLOCKSIZE (AMOUNT OF PLOTS OF LAND IN AN AREA ROW) // 16 
    // AREASIZE (TOTAL AMOUNT OF PLOTS OF LAND IN AN AREA) // 256 
    // MAXAREAS (AMOUNT OF AREAS IN THE WORLD) // 4096