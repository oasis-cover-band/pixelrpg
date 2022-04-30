//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
error InvalidHelperSender(address _target, address _sender);

interface ERC42069DataI {

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
        addressCheck(msg.sender);
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
        addressCheck(msg.sender);
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
        addressCheck(msg.sender);
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
        addressCheck(msg.sender);
        SG("CHARACTER", _NFT0ID, "MERGEDINTO", _createdNFTID);
        SG("CHARACTER", _NFT1ID, "MERGEDINTO", _createdNFTID);
        SG("CHARACTER", _createdNFTID, "MERGED", 1);
        SG("CHARACTER", _createdNFTID, "MERGED0", _NFT0ID);
        SG("CHARACTER", _createdNFTID, "MERGED1", _NFT1ID);
        mergeCharacters(_NFT0ID, _NFT1ID, _createdNFTID);
    }

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        uint256 _createdNFTID
    ) external {
        addressCheck(msg.sender);
        setCharacter(_level, _species, _special, _area, _createdNFTID);
    }

    function setCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        uint256 _createdNFTID) internal {
        uint256 r = dr() + _createdNFTID;
        setGeneralCharacter(
            10 + _level * (r % GS("STARTINGHEALTH")),
            10 + _level * (r % GS("STARTINGENERGY")),
            1 + _level * ((r + 415) % GS("STARTINGSTATS")),
            1 + _level * ((r + 948) % GS("STARTINGSTATS")),
            1 + _level * ((r + 307) % GS("STARTINGSTATS")),
            1 + _level * ((r + 81) % GS("STARTINGSTATS")),
            _createdNFTID);
        SG("CHARACTER", _createdNFTID, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", _createdNFTID, "FREESTATS", r % GS("STARTINGSTATS") + 3);
        SG("CHARACTER", _createdNFTID, "EXPERIENCE", 0);
        SG("CHARACTER", _createdNFTID, "LEVEL", _level);
        SG("CHARACTER", _createdNFTID, "SPECIES", _species);
        // SG("CHARACTER", _createdNFTID, "0", 0);
        // SG("CHARACTER", _createdNFTID, "1", 0);
        // SG("CHARACTER", _createdNFTID, "2", 0);
        // SG("CHARACTER", _createdNFTID, "3", 0);
        // SG("CHARACTER", _createdNFTID, "4", 0);
        // SG("CHARACTER", _createdNFTID, "5", 0);
        // SG("CHARACTER", _createdNFTID, MERGED, 0);
        // SG("CHARACTER", _createdNFTID, EVOLUTION, 0);
        // SG("CHARACTER", _createdNFTID, STATE, 0);
        setBasics(r, 0, _special, _area, _createdNFTID);
    }

    function mergeCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _createdNFTID) internal {
        uint256 r = dr() + _createdNFTID;
        setGeneralCharacter(
            GG("CHARACTER", _NFT0ID, "MAXHEALTH") + GG("CHARACTER", _NFT1ID, "MAXHEALTH"),
            GG("CHARACTER", _NFT0ID, "MAXENERGY") + GG("CHARACTER", _NFT1ID, "MAXENERGY"),
            GG("CHARACTER", _NFT0ID, "STRENGTH") + GG("CHARACTER", _NFT1ID, "STRENGTH"),
            GG("CHARACTER", _NFT0ID, "DEXTERITY") + GG("CHARACTER", _NFT1ID, "DEXTERITYY"),
            GG("CHARACTER", _NFT0ID, "INTELLIGENCE") + GG("CHARACTER", _NFT1ID, "INTELLIGENCE"),
            GG("CHARACTER", _NFT0ID, "CHARISMA") + GG("CHARACTER", _NFT1ID, "CHARISMA"),
            _createdNFTID);
        SG("CHARACTER", _createdNFTID, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", _createdNFTID, "FREESTATS", r % GS("STARTINGSTATS") + 3);
        SG("CHARACTER", _createdNFTID, "EXPERIENCE", 0);
        SG("CHARACTER", _createdNFTID, "LEVEL", GG("CHARACTER", _NFT0ID, "LEVEL") + GG("CHARACTER", _NFT1ID, "LEVEL"));
        SG("CHARACTER", _createdNFTID, "SPECIES", GG("CHARACTER", _NFT0ID, "SPECIES"));
        // SG("CHARACTER", _createdNFTID, "0", 0);
        // SG("CHARACTER", _createdNFTID, "1", 0);
        // SG("CHARACTER", _createdNFTID, "2", 0);
        // SG("CHARACTER", _createdNFTID, "3", 0);
        // SG("CHARACTER", _createdNFTID, "4", 0);
        // SG("CHARACTER", _createdNFTID, "5", 0);
        // SG("CHARACTER", _createdNFTID, MERGED, 1);
        // SG("CHARACTER", _createdNFTID, EVOLUTION, 0);
        // SG("CHARACTER", _createdNFTID, STATE, 0);
        setBasics(r, 0, 0, GG("GENERAL", _NFT0ID, "AREA"), _createdNFTID);
    }
    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _createdNFTID
    ) external {
        addressCheck(msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("EQUIPPABLE", _createdNFTID, "HEALTHBOOST", 10 + _level * (r % GS("MAXITEMHEALTH")));
        SG("EQUIPPABLE", _createdNFTID, "ENERGYBOOST", 10 + _level * (r % GS("MAXITEMENERGY")));
        SG("EQUIPPABLE", _createdNFTID, "STRENGTHBOOST", 1 * _level * ((r + 415) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "DEXTERITYBOOST", 1 * _level * ((r + 948) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "INTELLIGENCEBOOST", 1 * _level * ((r + 307) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "CHARISMABOOST", 1 * _level * ((r + 81) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", _createdNFTID, "EQUIPSLOT", _equipSlot);
        // SG("EQUIPPABLE", _createdNFTID, "EQUIPPEDBY", 0); 
        setBasics(r, 3, 0, 0, _createdNFTID);
    }

    function createNewProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _createdNFTID
    ) external {
        addressCheck(msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("PRODUCABLE", _createdNFTID, "PRODUCES", _produces);
        SG("PRODUCABLE", _createdNFTID, "PRODUCTION", 1 + _level * ((r + 49438249242378) % GS("MAXPRODUCTION")));
        SG("PRODUCABLE", _createdNFTID, "NEXTPRODUCTION", block.timestamp + GS("PRODUCTIONRESET")); 
        // SG("PRODUCABLE", _createdNFTID, "PLACEDIN", 0);
        setBasics(r, 4, 0, 0, _createdNFTID);
    }

    function createNewConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID,
        uint256 _createdNFTID
    ) external {
        addressCheck(msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("INVENTORY", _NFTID, _producableProductionType, GG("INVENTORY", _NFTID, _producableProductionType) - _amount);
        SG("CONSUMABLE", _createdNFTID, "TYPE", _producableProductionTypeUint);
        SG("CONSUMABLE", _createdNFTID, "AMOUNT", _amount);
        setBasics(r, 2, 0, 0, _createdNFTID);
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(msg.sender);
        SG("INVENTORY", _NFTID, d.n2s(GG("CONSUMABLE", _consumableNFTID, "TYPE")), GG("INVENTORY", _NFTID, d.n2s(GG("CONSUMABLE", _consumableNFTID, "TYPE"))) + GG("CONSUMABLE", _consumableNFTID, "AMOUNT"));
        SG("CONSUMABLE", _consumableNFTID, "AMOUNT", 0);
    }

    function createNewLot(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _createdNFTID
    ) external returns (uint256) {
        addressCheck(msg.sender);
        uint256 r = dr() + _createdNFTID;
        SG("LOT", _createdNFTID, "LOCATION", _locationUint);
        // SG("LOT", _createdNFTID, "0", 0);
        setBasics(r, 5, 0, _area, _createdNFTID);
        SG("WORLD", _area, _location, _createdNFTID);
        return _createdNFTID;
    }

    function createNewBuilding(
        uint256 _createdNFTID
    ) external returns (uint256) {
        SG("LOT", _createdNFTID, "BUILDING", 1);
        return _createdNFTID;
    }
    
    function expandBuilding(
        uint256 _NFTID,
        string memory _location,
        uint256 _up
    ) external {
        addressCheck(msg.sender);
        if (_up > 0) {
            SG("LOT", _NFTID, "STORIES", GG("LOT", _NFTID, "STORIES") + 1);
        } else {
            SG("LOT", _NFTID, "SIZE", GG("LOT", _NFTID, "SIZE") + 1);
            SG("WORLD", GG("GENERAL", _NFTID, "AREA"), _location, _NFTID);
        }
    }
    
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external returns (uint256) {
        addressCheck(msg.sender);
        uint256 producableNFTID = 0;
        if (GG("LOT", _NFTID, _location) != 0) {
            producableNFTID = internalRetrieveFromBuilding(_location, _buildingNFTID);
        }
        SG("PRODUCABLE", _NFTID, "PLACEDIN", _buildingNFTID);
        SG("LOT", _buildingNFTID, _location, _NFTID);
        return producableNFTID;
    }
    
    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(msg.sender);
        return internalRetrieveFromBuilding(_location, _NFTID);
    }
    
    function internalRetrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) internal returns (uint256) {
        uint256 producableNFTID = GG("LOT", _NFTID, _location);
        SG("PRODUCABLE", producableNFTID, "PLACEDIN", 0);
        SG("LOT", _NFTID, _location, 0);
        return producableNFTID;
    }
    
    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external {
        addressCheck(msg.sender);
        if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "HEALTHRESTORE") > 0) {
            SG("CHARACTER", _consumingNFTID, "HEALTH", GG("CHARACTER", _consumingNFTID, "MAXHEALTH"));
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "ENERGYRESTORE") > 0) {
            SG("CHARACTER", _consumingNFTID, "ENERGY", GG("CHARACTER", _consumingNFTID, "MAXENERGY"));
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "STRENGTHBOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "STRENGTH") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "STRENGTH", (GG("CHARACTER", _consumingNFTID, "STRENGTH")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "DEXTERITYBOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "DEXTERITY") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "DEXTERITY", (GG("CHARACTER", _consumingNFTID, "DEXTERITY")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "INTELLIGENCEBOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "INTELLIGENCE") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "INTELLIGENCE", (GG("CHARACTER", _consumingNFTID, "INTELLIGENCE")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "CHARISMABOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "CHARISMA") + _amount < GS("MAXTOTALSTATS")) {
                SG("CHARACTER", _consumingNFTID, "CHARISMA", (GG("CHARACTER", _consumingNFTID, "CHARISMA")) + _amount);
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "HEALTHBOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "MAXHEALTH") + _amount < GS("MAXTOTALHEALTH")) {
                SG("CHARACTER", _consumingNFTID, "MAXHEALTH", (GG("CHARACTER", _consumingNFTID, "MAXHEALTH")) + (_amount * (dr()% GS("STARTINGHEALTH"))));
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "ENERGYBOOST") > 0) {
            if (GG("CHARACTER", _consumingNFTID, "MAXENERGY") + _amount < GS("MAXTOTALENERGY")) {
                SG("CHARACTER", _consumingNFTID, "MAXENERGY", (GG("CHARACTER", _consumingNFTID, "MAXENERGY")) + (_amount * (dr()% GS("STARTINGENERGY"))));
            }
        } else if (GG("CONSUMABLETYPE", _producableProductionTypeUint, "BREEDINGRESET") > 0) {
            SG("CHARACTER", _consumingNFTID, "NEXTBREEDING", 1);
        }
        SG("INVENTORY", _NFTID, _producableProductionType, GG("INVENTORY", _NFTID, _producableProductionType) - _amount);
    }

    function setGeneralCharacter(
        uint256 _health,
        uint256 _energy,
        uint256 _strength,
        uint256 _dexterity,
        uint256 _intelligence,
        uint256 _charisma,
        uint256 _NFTID
    ) internal {
        SG("CHARACTER", _NFTID, "HEALTH", _health);
        SG("CHARACTER", _NFTID, "MAXHEALTH", _health);
        SG("CHARACTER", _NFTID, "ENERGY", _energy);
        SG("CHARACTER", _NFTID, "MAXENERGY", _energy);
        SG("CHARACTER", _NFTID, "STRENGTH", _strength);
        SG("CHARACTER", _NFTID, "DEXTERITY", _dexterity);
        SG("CHARACTER", _NFTID, "INTELLIGENCE", _intelligence);
        SG("CHARACTER", _NFTID, "CHARISMA", _charisma);
    }

    function setBasics(
        uint256 _dna,
        uint256 _type,
        uint256 _special,
        uint256 _area,
        uint256 _NFTID
    ) internal {
        SG("GENERAL", _NFTID, "DNA", _dna);
        SG("GENERAL", _NFTID, "TYPE", _type);
        SG("GENERAL", _NFTID, "SPECIAL", _special);
        SG("GENERAL", _NFTID, "AREA", _area);
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
        address _sender
    ) internal view {
        if (d.getAA("ERC42069") != _sender) {
            revert InvalidHelperSender({
                _target: d.getAA("ERC42069"),
                _sender: _sender
            });
        }
    }
}
