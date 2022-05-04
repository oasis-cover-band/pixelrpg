//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC42069I {

    function evolve(
        uint256 _NFTID
    ) external;

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
        uint256 _consumingNFTID,
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

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external;

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);
}
interface ERC20CreditsI {

    function burnCoins(uint256 _NFTID, uint256 _amount) external;

    function balanceOf(address account) external view returns (uint256);

    function gameTransferFrom(address _from, address _to, uint256 _amount) external;
}
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

    function getAA(string memory _name) external view returns (address);
    
    function r() external view returns (uint256);

    function n2s(uint _i) external pure returns (string memory);
    
    function getGS(string memory _setting) external view returns (uint256);
}
interface ERC42069RevertsI {
    
    function producableOrCharacterHasCompanionAndBusiness(
        uint256 _NFTID,
        uint256 _businessNFTID
    ) external view;

    function singleSpeciesCheck(
        uint256 _NFTID,
        uint256 _requiredSpecies
    ) external view;

    function companionCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) external view;

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) external view;

    function differsCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;

    function maxBuildingSizeCheck(
        uint256 _buildingNFTID,
        uint256 _location
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
        uint256 _location
    ) external view;

    function itemEquippedCheck(
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
    
    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function placeProducable(
        uint256 _NFTID,
        uint256 _location,
        uint256 _buildingNFTID
    ) external {
        addressCheck(GF(), msg.sender);
        // typeCheck(_NFTID, "_NFTID", 4); OR typeCheck(_NFTID, "_NFTID", 0) AND SPECIES 0 AND THIS BUILDING IS A BUSINESS OR GYM
        producableOrCharacterHasCompanionAndBusiness(_NFTID, _buildingNFTID);
        typeCheck(_buildingNFTID, "_BUILDINGNFTID", 5);
        maxBuildingSizeCheck(_buildingNFTID, _location);
        E().placeProducable(_NFTID, n2s(_location), _buildingNFTID);
    }

    function evolve(
        uint256 _NFTID
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        E().evolve(_NFTID);
    }

    function setCompanion(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 0);
        stateCheck(_NFT1ID, 0);
        companionCheck(_NFT0ID, _NFT1ID, "Invalid Species");
        SG("COMPANION", _NFT0ID, "0", _NFT1ID);
    }

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 5);
        E().retrieveFromBuilding(_location, _NFTID);
    }

    function expandBuilding(
        uint256 _NFTID,
        uint256 _location,
        uint256 _up
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 5);
        takeCredits(_NFTID, "EXPANDBUILDINGCOST");
        worldSpaceOccupancyCheck(GG("GENERAL", _NFTID, "AREA"), _location);
        maxAreaSizeCheck(_location);
        borderingWorldSpaceOccupancyCheck(GG("GENERAL", _NFTID, "AREA"), n2s(_location), _NFTID);
        E().expandBuilding(
            _NFTID,
            n2s(_location),
            _up
        );
    }

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        freeStatsBalanceCheck(_NFTID, _amount);
        E().giveStat(_NFTID, _amount, _statName);
    }
    
    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 0);
        stateCheck(_NFT1ID, 0);
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
        return E().breedTwoCharacters(_NFT0ID, _NFT1ID);
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        stateCheck(_NFT0ID, 0);
        stateCheck(_NFT1ID, 0);
        reproduceCheck(
            _NFT0ID,
            _NFT1ID,
            "MERGE",
            "MERGED",
            1
        );
        return E().mergeTwoCharacters(_NFT0ID, _NFT1ID);
    }
    
    function equip(
        uint256 _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        typeCheck(_equipNFTID, "_equipNFTID", 3);
        stateCheck(_NFTID, 0);
        singleSpeciesCheck(_NFTID, 0);
        if (GG("CHARACTER", _NFTID, n2s(_equipSlot)) != 0) {
            internalUnequip(n2s(_equipSlot), _NFTID);
        }
        
        E().gameTransferFrom(_equipNFTID, address(this));
        console.log("Equipped ERC42069 Token (Item): EquipNFTID:'%s' NFTID:'%s' Slot:'%s'", _equipNFTID, _NFTID, _equipSlot);
        SG("CHARACTER", _NFTID, "HEALTH", GG("CHARACTER", _NFTID, "HEALTH") + GG("EQUIPPABLE", _equipNFTID, "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "MAXHEALTH", GG("CHARACTER", _NFTID, "MAXHEALTH") + GG("EQUIPPABLE", _equipNFTID, "HEALTHBOOST"));
        SG("CHARACTER", _NFTID, "ENERGY", GG("CHARACTER", _NFTID, "ENERGY") + GG("EQUIPPABLE", _equipNFTID, "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "MAXENERGY", GG("CHARACTER", _NFTID, "MAXENERGY") + GG("EQUIPPABLE", _equipNFTID, "ENERGYBOOST"));
        SG("CHARACTER", _NFTID, "STRENGTH", GG("CHARACTER", _NFTID, "STRENGTH") + GG("EQUIPPABLE", _equipNFTID, "STRENGTHBOOST"));
        SG("CHARACTER", _NFTID, "DEXTERITY", GG("CHARACTER", _NFTID, "DEXTERITY") + GG("EQUIPPABLE", _equipNFTID, "DEXTERITYBOOST"));
        SG("CHARACTER", _NFTID, "INTELLIGENCE", GG("CHARACTER", _NFTID, "INTELLIGENCE") + GG("EQUIPPABLE", _equipNFTID, "INTELLIGENCEBOOST"));
        SG("CHARACTER", _NFTID, "CHARISMA", GG("CHARACTER", _NFTID, "CHARISMA") + GG("EQUIPPABLE", _equipNFTID, "CHARISMABOOST"));
        
        SG("CHARACTER", _NFTID, n2s(_equipSlot), _equipNFTID);
    }

    function takeCredits(uint256 _NFTID, string memory _costs) internal {
        balanceCheck(E().ownerOf(_NFTID), GS(_costs));
        ERC20CreditsI(AA("ERC20CREDITS")).burnCoins(_NFTID, 3 * (GS(_costs) / 4));
        ERC20CreditsI(AA("ERC20CREDITS")).gameTransferFrom(E().ownerOf(_NFTID), AA("TREASURY"), GS(_costs) / 4);
    }

    function unequip(
        uint256 _equipSlot,
        uint256 _NFTID
    ) public {
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        stateCheck(_NFTID, 0);
        itemEquippedCheck(GG("CHARACTER", _NFTID, n2s(_equipSlot)), _equipSlot, _NFTID);
        internalUnequip(n2s(_equipSlot), _NFTID);
    }

    function internalUnequip(
        string memory _equipSlot,
        uint256 _NFTID) internal {
        E().gameTransferFrom(GG("CHARACTER", _NFTID, _equipSlot), E().ownerOf(_NFTID));
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
        addressCheck(GF(), msg.sender);
        typeCheck(_NFTID, "_NFTID", 0);
        stateCheck(_NFTID, 0);
        timerCheck(GG("PRODUCABLE", _producableNFTID, "NEXTPRODUCTION"), block.timestamp, "PRODUCE");
        SG("PRODUCABLE", _producableNFTID, "NEXTPRODUCTION", block.timestamp + GS("PRODUCTIONRESET")); 
        SG(
            "INVENTORY",
            _NFTID,
            n2s(GG("PRODUCABLE", _producableNFTID, "PRODUCES")),
            GG("INVENTORY", _NFTID, n2s(GG("PRODUCABLE", _producableNFTID, "PRODUCES")))
            + d.r() % GG("PRODUCABLE", _producableNFTID, "PRODUCTION")
        ); 
    }

    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        uint256 _producableProductionType,
        uint256 _amount
    ) external {
        addressCheck(GF(), msg.sender);
        consumableBalanceCheck(_NFTID, n2s(_producableProductionType), _amount);
        stateCheck(_consumingNFTID, 0);
        typeCheck(_NFTID, "_NFTID", 0);
        typeCheck(_consumingNFTID, "_NFTID", 0);
        E().consume(
            _NFTID,
            _consumingNFTID,
            n2s(_producableProductionType),
            _producableProductionType,
            _amount
        );
    }

    function GF() internal view returns (address) {
        return AA("GREATFILTER");
    }

    function E() internal view returns (ERC42069I) {
        return ERC42069I(AA("ERC42069"));
    }

    function RV() internal view returns (ERC42069RevertsI) {
        return ERC42069RevertsI(AA("ERC42069REVERTS"));
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
        differsCheck(_NFT0ID, _NFT1ID);
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        speciesCheck(_NFT0ID, _NFT1ID, _speciesCheck);
        timerCheck(GG("CHARACTER", _NFT0ID, _timerCheck), _timerValue, "REPRODUCENFT0");
        timerCheck(GG("CHARACTER", _NFT1ID, _timerCheck), _timerValue, "REPRODUCENFT1");
    }

    function n2s(uint _i) internal view returns (string memory) {
        return d.n2s(_i);
    }

    function borderingWorldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location,
        uint256 _NFTID
    ) internal view {
        RV().borderingWorldSpaceOccupancyCheck(_area, _location, _NFTID);
    }

    function maxAreaSizeCheck(
        uint256 _location
    ) internal view {
        RV().maxAreaSizeCheck(_location);
    }

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) internal view {
        RV().stateCheck(_NFTID, _requiredState);
    }

    function differsCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().differsCheck(_NFT0ID, _NFT1ID);
    }

    function maxBuildingSizeCheck(
        uint256 _buildingNFTID,
        uint256 _location
    ) internal view {
        RV().maxBuildingSizeCheck(_buildingNFTID, _location);
    }

    function worldSpaceOccupancyCheck(
        uint256 _area,
        uint256 _location
    ) internal view {
        RV().worldSpaceOccupancyCheck(_area, _location);
    }

    function itemEquippedCheck(
        uint256 _current,
        uint256 _equipSlot,
        uint256 _NFTID
    ) internal view {
        RV().itemEquippedCheck(_current, _equipSlot, _NFTID);
    }

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) internal view {
        RV().typeCheck(_NFTID, _variableName, _type);
    }

    function singleSpeciesCheck(
        uint256 _NFTID,
        uint256 _requiredSpecies
    ) internal view {
        RV().singleSpeciesCheck(_NFTID, _requiredSpecies);
    }

    function speciesCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) internal view {
        RV().speciesCheck(_NFT0ID, _NFT1ID, _variableName);
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        RV().addressCheck(_target, _sender);
    }

    function companionCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _value
    ) internal view {
        RV().companionCheck(_NFT0ID, _NFT1ID, _value);
    }
    
    function producableOrCharacterHasCompanionAndBusiness(
        uint256 _NFTID,
        uint256 _businessNFTID
    ) internal view {
        RV().producableOrCharacterHasCompanionAndBusiness(
            _NFTID,
            _businessNFTID
        );
    }

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) internal view {
        RV().timerCheck(_value, _mustBeBefore, _timerName);
    }

    function balanceCheck(
        address _from,
        uint256 _amount
    ) internal view {
        RV().balanceCheck(_from, _amount);
    }

    function consumableBalanceCheck(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _amount
    ) internal view {
        RV().consumableBalanceCheck(_NFTID, _producableProductionType, _amount);
    }

    function freeStatsBalanceCheck(
        uint256 _NFTID,
        uint256 _amount
    ) internal view {
        RV().freeStatsBalanceCheck(_NFTID, _amount);
    }
}
