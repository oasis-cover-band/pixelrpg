//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC42069 {
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external;


    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external;

    function expandBuilding(
        uint256 _NFTID,
        string memory _location,
        uint256 _up
    ) external;

    function consume(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external;

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external;

    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256);

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256);

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external returns (uint256);

    function createNewConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID
    ) external returns (uint256);
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external;

    function createNewProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256);

    function createNewEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256);

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256);

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external;

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);
}
interface ERC20Credits {

    function burnCoins(uint256 _NFTID, uint256 _amount) external;

    function balanceOf(address account) external view returns (uint256);

    function gameTransferFrom(address _from, address _to, uint256 _amount) external;
}
interface ERC42069Data {

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

    function getAA(string memory _name) external view returns (address);
    
    function r() external view returns (uint256);

    function s2n(string memory numString) external pure returns(uint);

    function n2s(uint _i) external pure returns (string memory);
    
    function getGS(string memory _setting) external view returns (uint256);
}
interface ERC42069Reverts {

    function maxBuildingSizeCheck(
        uint256 _buildingNFTID,
        string memory _location
    ) external view;

    function reproduceCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _speciesCheck,
        string memory _timerCheck,
        uint256 _timerValue
    ) external view;

    function sameNumberCheck(
        uint256 _uint,
        string memory _string
    ) external view;

    function borderingWorldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location,
        uint256 _NFTID
    ) external view;

    function maxAreaSizeCheck(
        uint256 _location
    ) external view;

    function worldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location
    ) external view;

    function itemEquippedChecked(
        uint256 _current,
        uint256 _equipSlotUint,
        uint256 _NFTID
    ) external pure;

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) external view;

    function speciesCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) external view;

    function addressCheck(
        address _target,
        address _sender
    ) external pure;

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) external pure;

    function balanceCheck(
        address _from,
        uint256 _amount
    ) external view;

    function consumableBalanceCheck(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _amount
    ) external view;

    function freeStatsBalanceCheck(
        uint256 _NFTID,
        uint256 _amount
    ) external view;
}
contract GameMaster {
    
    ERC42069Data d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069Data(_dataAddress);
    }

    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 4);
        typeCheck(_buildingNFTID, "_BUILDINGNFTID", 5);
        maxBuildingSizeCheck(_buildingNFTID, _location);
        ERC42069(AA("ERC42069")).placeProducable(_NFTID, _location, _buildingNFTID);
    }

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 5);
        ERC42069(AA("ERC42069")).retrieveFromBuilding(_location, _NFTID);
    }

    function expandBuilding(
        uint256 _NFTID,
        string memory _location,
        uint256 _locationUint,
        uint256 _up
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 5);
        takeCredits(_NFTID, "EXPANDBUILDINGCOST");
        sameNumberCheck(_locationUint, _location);
        worldSpaceOccupancyCheck(GG("GENERAL", _NFTID, "AREA"), _location);
        maxAreaSizeCheck(_locationUint);
        borderingWorldSpaceOccupancyCheck(GG("GENERAL", _NFTID, "AREA"), _location, _NFTID);
        ERC42069(AA("ERC42069")).expandBuilding(
            _NFTID,
            _location,
            _up
        );
    }

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        freeStatsBalanceCheck(_NFTID, _amount);
        ERC42069(AA("ERC42069")).giveStat(_NFTID, _amount, _statName);
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        typeCheck(_consumableNFTID, "_consumableNFTID", 2);
        ERC42069(AA("ERC42069")).destroyConsumable(_NFTID, _consumableNFTID);
    }
    
    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender); // SHOULD BE CHANG3D TO MINTER!!
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        speciesCheck(_NFT0ID, _NFT1ID, "BREED");
        timerCheck(GG("CHARACTER", _NFT0ID, "NEXTBREEDING"), block.timestamp, "BREEDNFT0");
        timerCheck(GG("CHARACTER", _NFT1ID, "NEXTBREEDING"), block.timestamp, "BREEDNFT1");
        reproduceCheck(
            _NFT0ID,
            _NFT1ID,
            "BREED",
            "NEXTBREEDING",
            block.timestamp
        );
        ERC42069(AA("ERC42069")).breedTwoCharacters(_NFT0ID, _NFT1ID);
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender); // SHOULD BE CHANG3D TO MINTER!!
        reproduceCheck(
            _NFT0ID,
            _NFT1ID,
            "MERGE",
            "MERGED",
            1
        );
        ERC42069(AA("ERC42069")).mergeTwoCharacters(_NFT0ID, _NFT1ID);
    }

    function newCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender); // SHOULD BE CHANG3D TO MINTER!!
        ERC42069(AA("ERC42069")).createNewCharacter(_level, _species, _special, _area, _mintTo);
    }

    function newConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        consumableBalanceCheck(_NFTID, _producableProductionType, _amount);
        sameNumberCheck(_producableProductionTypeUint, _producableProductionType);
        typeCheck(_NFTID, "_NFTID", 0);
        ERC42069(AA("ERC42069")).createNewConsumable(_amount, _producableProductionType, _producableProductionTypeUint, _NFTID);
    }

    function newProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        ERC42069(AA("ERC42069")).createNewProducable(_level, _produces, _NFTID);
        takeCredits(_NFTID, "PRODUCABLECOST");
    }
    
    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        ERC42069(AA("ERC42069")).createNewEquippable(_level, _itemSlot, _NFTID);
        takeCredits(_NFTID, "EQUIPPABLECOST");
    }

    function newBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        worldSpaceOccupancyCheck(_area, _location);
        sameNumberCheck(_locationUint, _location);
        maxAreaSizeCheck(_locationUint);
        ERC42069(AA("ERC42069")).createNewBuilding(_area, _location, _locationUint, _NFTID);
        takeCredits(_NFTID, "BUILDINGCOST");
    }
    
    function equip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        sameNumberCheck(_equipSlotUint, _equipSlot);
        typeCheck(_NFTID, "_NFTID", 0);
        typeCheck(_equipNFTID, "_equipNFTID", 3);
        if (GG("CHARACTER", _NFTID, _equipSlot) != 0) {
            internalUnequip(_equipSlot, _NFTID);
        }
        
        ERC42069(AA("ERC42069")).gameTransferFrom(_equipNFTID, address(this));
        console.log("Equipped ERC42069 Token (Item): EquipNFTID:'%s' NFTID:'%s' Slot:'%s'", _equipNFTID, _NFTID, _equipSlot);
        SG("CHARACTER", _NFTID, "HEALTH", GG("CHARACTER", _NFTID, "HEALTH") + GG("EQUIPPABLE", _equipNFTID, "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "MAXHEALTH", GG("CHARACTER", _NFTID, "MAXHEALTH") + GG("EQUIPPABLE", _equipNFTID, "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "ENERGY", GG("CHARACTER", _NFTID, "ENERGY") + GG("EQUIPPABLE", _equipNFTID, "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "MAXENERGY", GG("CHARACTER", _NFTID, "MAXENERGY") + GG("EQUIPPABLE", _equipNFTID, "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "STRENGTH", GG("CHARACTER", _NFTID, "STRENGTH") + GG("EQUIPPABLE", _equipNFTID, "STRENGTHBOOST"));
        SG("CHARACTER", _NFTID, "DEXTERITY", GG("CHARACTER", _NFTID, "DEXTERITY") + GG("EQUIPPABLE", _equipNFTID, "DEXTERITYBOOST"));
        SG("CHARACTER", _NFTID, "INTELLIGENCE", GG("CHARACTER", _NFTID, "INTELLIGENCE") + GG("EQUIPPABLE", _equipNFTID, "INTELLIGENCEBOOST"));
        SG("CHARACTER", _NFTID, "CHARISMA", GG("CHARACTER", _NFTID, "CHARISMA") + GG("EQUIPPABLE", _equipNFTID, "CHARISMABOOST"));
        
        SG("CHARACTER", _NFTID, _equipSlot, _equipNFTID);
    }

    function takeCredits(uint256 _NFTID, string memory _costs) internal {
        balanceCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), GS(_costs));
        ERC20Credits(AA("ERC20CREDITS")).burnCoins(_NFTID, 3 * (GS(_costs) / 4));
        ERC20Credits(AA("ERC20CREDITS")).gameTransferFrom(ERC42069(AA("ERC42069")).ownerOf(_NFTID), AA("TREASURY"), GS(_costs) / 4);
    }

    function unequip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _NFTID
    ) public {
        addressCheck(AA("GREATFILTER"), msg.sender);
        sameNumberCheck(_equipSlotUint, _equipSlot);
        typeCheck(_NFTID, "_NFTID", 0);
        itemEquippedChecked(GG("CHARACTER", _NFTID, _equipSlot), _equipSlotUint, _NFTID);
        internalUnequip(_equipSlot, _NFTID);
    }

    function internalUnequip(
        string memory _equipSlot,
        uint256 _NFTID) internal {
        ERC42069(AA("ERC42069")).gameTransferFrom(GG("CHARACTER", _NFTID, _equipSlot), ERC42069(AA("ERC42069")).ownerOf(_NFTID));
        console.log("Unequipped ERC42069 Token (Item): UnequipNFTID:'%s' fromNFTID:'%s' Slot:'%s'", GG("CHARACTER", _NFTID, _equipSlot), _NFTID, _equipSlot);
        SG("CHARACTER", _NFTID, "HEALTH", GG("CHARACTER", _NFTID, "HEALTH") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "MAXHEALTH", GG("CHARACTER", _NFTID, "MAXHEALTH") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "ENERGY", GG("CHARACTER", _NFTID, "ENERGY") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "MAXENERGY", GG("CHARACTER", _NFTID, "MAXENERGY") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "STRENGTH", GG("CHARACTER", _NFTID, "STRENGTH") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "STRENGTHBOOST"));
        SG("CHARACTER", _NFTID, "DEXTERITY", GG("CHARACTER", _NFTID, "DEXTERITY") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "DEXTERITYBOOST"));
        SG("CHARACTER", _NFTID, "INTELLIGENCE", GG("CHARACTER", _NFTID, "INTELLIGENCE") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "INTELLIGENCEBOOST"));
        SG("CHARACTER", _NFTID, "CHARISMA", GG("CHARACTER", _NFTID, "CHARISMA") - GG("EQUIPPABLE", GG("CHARACTER", _NFTID, _equipSlot), "CHARISMABOOST"));
        
        SG("CHARACTER", _NFTID, _equipSlot, 0);
    }
    
    function produce(
        uint256 _NFTID,
        uint256 _producableNFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        timerCheck(GG("PRODUCABLE", _producableNFTID, "NEXTPRODUCTION"), block.timestamp, "PRODUCE");
        SG("PRODUCABLE", _producableNFTID, "NEXTPRODUCTION", block.timestamp + GS("PRODUCTIONRESET")); 
        SG(
            "INVENTORY",
            _NFTID,
            d.n2s(GG("PRODUCABLE", _producableNFTID, "PRODUCES")),
            GG("INVENTORY", _NFTID, d.n2s(GG("PRODUCABLE", _producableNFTID, "PRODUCES")))
            + d.r() % GG("PRODUCABLE", _producableNFTID, "PRODUCTION")
        ); 
    }

    function consume(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        consumableBalanceCheck(_NFTID, _producableProductionType, _amount);
        sameNumberCheck(_producableProductionTypeUint, _producableProductionType);
        typeCheck(_NFTID, "_NFTID", 0);
        ERC42069(AA("ERC42069")).consume(
            _NFTID,
            _producableProductionType,
            _producableProductionTypeUint,
            _amount
        );
    }

    function AA(
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
    }

    function SG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue
    ) internal {
            d.setGD(_symbol, _NFTID, _statName, _statValue, "GAMEMASTER");
    }
    
    function GS(
        string memory _setting
    ) internal view returns (uint256) {
            return d.getGS(_setting);
    }

    function GG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) internal view returns (uint256) {
        return d.getGD(_symbol, _NFTID, _statName);
    }

    function reproduceCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _speciesCheck,
        string memory _timerCheck,
        uint256 _timerValue
    ) internal view {
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        speciesCheck(_NFT0ID, _NFT1ID, _speciesCheck);
        timerCheck(GG("CHARACTER", _NFT0ID, _timerCheck), _timerValue, "REPRODUCENFT0");
        timerCheck(GG("CHARACTER", _NFT1ID, _timerCheck), _timerValue, "REPRODUCENFT1");
    }

    function sameNumberCheck(
        uint256 _uint,
        string memory _string
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).sameNumberCheck(_uint, _string);
    }

    function borderingWorldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location,
        uint256 _NFTID
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).borderingWorldSpaceOccupancyCheck(_area, _location, _NFTID);
    }

    function maxAreaSizeCheck(
        uint256 _location
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).maxAreaSizeCheck(_location);
    }

    function maxBuildingSizeCheck(
        uint256 _buildingNFTID,
        string memory _location
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).maxBuildingSizeCheck(_buildingNFTID, _location);
    }

    function worldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).worldSpaceOccupancyCheck(_area, _location);
    }

    function itemEquippedChecked(
        uint256 _current,
        uint256 _equipSlotUint,
        uint256 _NFTID
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).itemEquippedChecked(_current, _equipSlotUint, _NFTID);
    }

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).typeCheck(_NFTID, _variableName, _type);
    }

    function speciesCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).speciesCheck(_NFT0ID, _NFT1ID, _variableName);
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).addressCheck(_target, _sender);
    }

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).timerCheck(_value, _mustBeBefore, _timerName);
    }

    function balanceCheck(
        address _from,
        uint256 _amount
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).balanceCheck(_from, _amount);
    }

    function consumableBalanceCheck(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _amount
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).consumableBalanceCheck(_NFTID, _producableProductionType, _amount);
    }

    function freeStatsBalanceCheck(
        uint256 _NFTID,
        uint256 _amount
    ) internal view {
        ERC42069Reverts(AA("ERC42069REVERTS")).freeStatsBalanceCheck(_NFTID, _amount);
    }
}
