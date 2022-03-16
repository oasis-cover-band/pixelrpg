//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error InvalidHelperSender(address _target, address _sender);

interface NameGeneratorI {
     function getRandomName() external view returns (string memory);
}
interface ERC42069DataI {

    function setGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue,
        string memory _msgSender
    ) external;

    function setGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue,
        string memory _msgSender
    ) external;

    function getGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) external view returns (uint256);

    function r() external view returns (uint256);

    function getGS(string memory _setting) external view returns (uint256);

    function getAA(string memory _name) external view returns (address);

    function n2s(uint _i) external pure returns (string memory);
}

contract ERC42069Helper {

    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function gainExperience(
        uint256 _amount,
        uint256 _NFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        if (
            (GG("CHARACTER",_NFTID, "EXPERIENCE") + _amount) > GG("CHARACTER",_NFTID, "LEVEL") *  GS("LEVELUP") &&
            GG("CHARACTER", _NFTID, "LEVEL") + 1 < GS("MAXTOTALLEVEL")
        ) {
            SG("CHARACTER", _NFTID, "LEVEL", GG("CHARACTER",_NFTID, "LEVEL") + 1);
            SG("CHARACTER", _NFTID, "EXPERIENCE", 0);
            SG("CHARACTER", _NFTID, "FREESTATS", GG("CHARACTER",_NFTID, "FREESTATS") + 1 + (dr()% GS("MAXLEVELSTATS")));
        } else {
            SG("CHARACTER", _NFTID, "EXPERIENCE", (GG("CHARACTER",_NFTID, "EXPERIENCE") + _amount));
        }
    }
    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        if(GG("CHARACTER", _NFTID, _statName) + _amount < GS("MAXTOTALSTATS")) {
            SG("CHARACTER", _NFTID, "FREESTATS", GG("CHARACTER", _NFTID, "FREESTATS") - _amount);
            SG("CHARACTER", _NFTID, _statName, GG("CHARACTER", _NFTID, _statName) + _amount);
        }
    }

    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        SG("CHARACTER", _NFT0ID, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", _NFT1ID, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", _createdNFTID, "BRED", 1);
        SG("CHARACTER", _createdNFTID, "PARENT0", _NFT0ID);
        SG("CHARACTER", _createdNFTID, "PARENT1", _NFT1ID);
        setCharacter(1, GG("CHARACTER", _NFT0ID, "SPECIES"), 0,  GG("CHARACTER", _NFT0ID, "AREA"), _createdNFTID);
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        SG("CHARACTER", _NFT0ID, "MERGEDINTO", _createdNFTID);
        SG("CHARACTER", _NFT1ID, "MERGEDINTO", _createdNFTID);
        SG("CHARACTER", _createdNFTID, "MERGED", 1);
        SG("CHARACTER", _createdNFTID, "MERGED0", _NFT0ID);
        SG("CHARACTER", _createdNFTID, "MERGED1", _NFT1ID);
        setCharacter(GG("CHARACTER", _NFT0ID, "LEVEL") + GG("CHARACTER", _NFT0ID, "LEVEL"), GG("CHARACTER", _NFT0ID, "SPECIES"), 0, GG("CHARACTER", _NFT0ID, "AREA"), _createdNFTID);
    }

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        setCharacter(_level, _species, _special, _area, _createdNFTID);
    }

    function setCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        uint256 _createdNFTID) internal {
        uint256 r = dr() + _createdNFTID;
        SG("CHARACTER", _createdNFTID, "HEALTH", 10 + _level * (r % GS("STARTINGHEALTH")));
        SG("CHARACTER", _createdNFTID, "MAXHEALTH", 10 + _level * (r % GS("STARTINGHEALTH")));
        SG("CHARACTER", _createdNFTID, "ENERGY", 10 + _level * (r % GS("STARTINGENERGY")));
        SG("CHARACTER", _createdNFTID, "MAXENERGY", 10 + _level * (r % GS("STARTINGENERGY")));
        SG("CHARACTER", _createdNFTID, "STRENGTH", 1 + _level * ((r + 415) % GS("STARTINGSTATS")));
        SG("CHARACTER", _createdNFTID, "DEXTERITY", 1 + _level * ((r + 948) % GS("STARTINGSTATS")));
        SG("CHARACTER", _createdNFTID, "INTELLIGENCE", 1 + _level * ((r + 307) % GS("STARTINGSTATS")));
        SG("CHARACTER", _createdNFTID, "CHARISMA", 1 + _level * ((r + 81) % GS("STARTINGSTATS")));
        SG("CHARACTER", _createdNFTID, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", _createdNFTID, "FREESTATS", r % GS("STARTINGSTATS") + 3);
        SG("CHARACTER", _createdNFTID, "EXPERIENCE", 0);
        SG("CHARACTER", _createdNFTID, "LEVEL", _level);
        SG("CHARACTER", _createdNFTID, "SPECIES", _species);
        SGN("GENERAL", _createdNFTID, "NAME", NameGeneratorI(AA("NAMEGENERATOR")).getRandomName());
        console.log(NameGeneratorI(AA("NAMEGENERATOR")).getRandomName(), "NameGeneratorI(AA(NAMEGENERATOR)).getRandomName()");
        // SG("CHARACTER", _createdNFTID, "0", 0);
        // SG("CHARACTER", _createdNFTID, "1", 0);
        // SG("CHARACTER", _createdNFTID, "2", 0);
        // SG("CHARACTER", _createdNFTID, "3", 0);
        // SG("CHARACTER", _createdNFTID, "4", 0);
        // SG("CHARACTER", _createdNFTID, "5", 0);
        // SG("CHARACTER", _createdNFTID, MERGED, 0);
        // SG("CHARACTER", _createdNFTID, EVOLUTION, 0);
        // SG("CHARACTER", _createdNFTID, STATE, 0);
        SG("GENERAL", _createdNFTID, "DNA", r);
        SG("GENERAL", _createdNFTID, "TYPE", 0);
        SG("GENERAL", _createdNFTID, "SPECIAL", _special);
        SG("GENERAL", _createdNFTID, "AREA", _area);
    }
    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("EQUIPPABLE", _createdNFTID, "HEALTHBOOST", 10 + _level * (r % GS("MAXITEMHEALTH")));
        SG("EQUIPPABLE", _createdNFTID, "ENERGYBOOST", 10 + _level * (r % GS("MAXITEMENERGY")));
        SG("EQUIPPABLE", _createdNFTID, "STRENGTHBOOST", 1 * _level * ((r + 415) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "DEXTERITYBOOST", 1 * _level * ((r + 948) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "INTELLIGENCEBOOST", 1 * _level * ((r + 307) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "CHARISMABOOST", 1 * _level * ((r + 81) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "EQUIPSLOT", _equipSlot);
        // SG("EQUIPPABLE", _createdNFTID, "EQUIPPEDBY", 0); 
        SG("GENERAL", _createdNFTID, "DNA", r);
        SG("GENERAL", _createdNFTID, "TYPE", 3);
    }

    function createNewProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("PRODUCABLE", _createdNFTID, "PRODUCES", _produces);
        SG("PRODUCABLE", _createdNFTID, "PRODUCTION", 1 + _level * ((r + 49438249242378) % GS("MAXPRODUCTION")));
        SG("PRODUCABLE", _createdNFTID, "NEXTPRODUCTION", block.timestamp + GS("PRODUCTIONRESET")); 
        // SG("PRODUCABLE", _createdNFTID, "PLACEDIN", 0);
        SG("GENERAL", _createdNFTID, "DNA", r);
        SG("GENERAL", _createdNFTID, "TYPE", 4);
    }

    function createNewConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID,
        uint256 _createdNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("INVENTORY", _NFTID, _producableProductionType, GG("INVENTORY", _NFTID, _producableProductionType) - _amount);
        SG("CONSUMABLE", _createdNFTID, "TYPE", _producableProductionTypeUint);
        SG("CONSUMABLE", _createdNFTID, "AMOUNT", _amount);
        SG("GENERAL", _createdNFTID, "DNA", r);
        SG("GENERAL", _createdNFTID, "TYPE", 2);
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        SG("INVENTORY", _NFTID, d.n2s(GG("CONSUMABLE", _consumableNFTID, "TYPE")), GG("INVENTORY", _NFTID, d.n2s(GG("CONSUMABLE", _consumableNFTID, "TYPE"))) + GG("CONSUMABLE", _consumableNFTID, "AMOUNT"));
        SG("CONSUMABLE", _consumableNFTID, "AMOUNT", 0);
    }

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _createdNFTID
    ) external returns (uint256) {
        addressCheck(AA("ERC42069"), msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("BUILDING", _createdNFTID, "SIZE", 1);
        SG("BUILDING", _createdNFTID, "STORIES", 1);
        SG("BUILDING", _createdNFTID, "LOCATION", _locationUint);
        // SG("BUILDING", _createdNFTID, "0", 0);
        SG("GENERAL", _createdNFTID, "TYPE", 5);
        SG("GENERAL", _createdNFTID, "DNA", r);
        SG("GENERAL", _createdNFTID, "AREA", _area);
        SG("WORLD", _area, _location, _createdNFTID);
        return _createdNFTID;
    }
    
    function expandBuilding(
        uint256 _NFTID,
        string memory _location,
        uint256 _up
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        if (_up > 0) {
            SG("BUILDING", _NFTID, "STORIES", GG("BUILDING", _NFTID, "STORIES") + 1);
        } else {
            SG("BUILDING", _NFTID, "SIZE", GG("BUILDING", _NFTID, "SIZE") + 1);
            SG("WORLD", GG("GENERAL", _NFTID, "AREA"), _location, _NFTID);
        }
    }
    
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external returns (uint256) {
        addressCheck(AA("ERC42069"), msg.sender);
        uint256 producableNFTID = 0;
        if (GG("BUILDING", _NFTID, _location) != 0) {
            producableNFTID = internalRetrieveFromBuilding(_location, _buildingNFTID);
        }
        SG("PRODUCABLE", _NFTID, "PLACEDIN", _buildingNFTID);
        SG("BUILDING", _buildingNFTID, _location, _NFTID);
        return producableNFTID;
    }
    
    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("ERC42069"), msg.sender);
        return internalRetrieveFromBuilding(_location, _NFTID);
    }
    
    function internalRetrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) internal returns (uint256) {
        uint256 producableNFTID = GG("BUILDING", _NFTID, _location);
        SG("PRODUCABLE", producableNFTID, "PLACEDIN", 0);
        SG("BUILDING", _NFTID, _location, 0);
        return producableNFTID;
    }
    
    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external {
        addressCheck(AA("ERC42069"), msg.sender);
        if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "HEALTHRESTORE") > 1) {
            SG("CHARACTER", _consumingNFTID, "HEALTH", GG("CHARACTER", _consumingNFTID, "MAXHEALTH"));
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "ENERGYRESTORE") > 1) {
            SG("CHARACTER", _consumingNFTID, "ENERGY", GG("CHARACTER", _consumingNFTID, "MAXENERGY"));
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "STRENGTHBOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "STRENGTH") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "STRENGTH", (GG("CHARACTER", _consumingNFTID, "STRENGTH")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "DEXTERITYBOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "DEXTERITY") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "DEXTERITY", (GG("CHARACTER", _consumingNFTID, "DEXTERITY")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "INTELLIGENCEBOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "INTELLIGENCE") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "INTELLIGENCE", (GG("CHARACTER", _consumingNFTID, "INTELLIGENCE")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "CHARISMABOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "CHARISMA") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "CHARISMA", (GG("CHARACTER", _consumingNFTID, "CHARISMA")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "HEALTHBOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "MAXHEALTH") + _amount < GS("MAXTOTALHEALTH")) {
                SG("CHARACTER", _consumingNFTID, "MAXHEALTH", (GG("CHARACTER", _consumingNFTID, "MAXHEALTH")) + (_amount * (dr()% GS("STARTINGHEALTH"))));
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "ENERGYBOOST") > 1) {
            if (GG("CHARACTER", _consumingNFTID, "MAXENERGY") + _amount < GS("MAXTOTALENERGY")) {
                SG("CHARACTER", _consumingNFTID, "MAXENERGY", (GG("CHARACTER", _consumingNFTID, "MAXENERGY")) + (_amount * (dr()% GS("STARTINGENERGY"))));
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "BREEDINGRESET") > 1) {
            SG("CHARACTER", _consumingNFTID, "NEXTBREEDING", 1);
        }
        SG("INVENTORY", _NFTID, _producableProductionType, GG("INVENTORY", _NFTID, _producableProductionType) - _amount);
    }

    function AA (
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
    }

    function SG (
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue
    ) internal {
            d.setGD(_symbol, _NFTID, _statName, _statValue, "ERC42069HELPER");
    }

    function GS (
        string memory _setting
    ) internal view returns (uint256) {
            return d.getGS(_setting);
    }

    function SGN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue
    ) internal {
            d.setGDN(_symbol, _NFTID, _statName, _statValue, "ERC42069HELPER");
    }

    function dr() internal view returns (uint256) {
        return d.r();
    }

    function GG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) internal view returns (uint256) {
        return d.getGD(_symbol, _NFTID, _statName);
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal pure {
        if (_target != _sender) {
            revert InvalidHelperSender({
                _target: _target,
                _sender: _sender
            });
        }
    }
}
