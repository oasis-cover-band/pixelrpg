//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

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

    function n2s(uint _i) external pure returns (string memory);
    
    function getGS(string memory _setting) external view returns (uint256);
}
interface ERC20CreditsI {

    function burnCoins(uint256 _NFTID, uint256 _amount) external;

    function gameTransferFrom(address _from, address _to, uint256 _amount) external;
}
interface ERC42069I {

    function ownerOf(
        uint256 _NFTID
    ) external returns (address); 

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
}
interface ERC42069RevertsI {

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) external view;

    function itemSlotCheck(
        uint256 _equipSlotUint
    ) external view;

    function maxAreaSizeCheck(
        uint256 _location
    ) external view;

    function worldSpaceOccupancyCheck(
        uint256 _area,
        uint256 _location
    ) external view;

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) external view;

    function addressCheck(
        address _target,
        address _sender
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
}
contract MintMaster {
    
    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function takeCredits(uint256 _NFTID, string memory _costs) internal {
        balanceCheck(E().ownerOf(_NFTID), GS(_costs));
        ERC20CreditsI(AA("ERC20CREDITS")).burnCoins(_NFTID, 3 * (GS(_costs) / 4));
        ERC20CreditsI(AA("ERC20CREDITS")).gameTransferFrom(E().ownerOf(_NFTID), AA("TREASURY"), GS(_costs) / 4);
    }

    function generateCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256) {
        addressCheck(AA("SETUP"), msg.sender);
        return E().createNewCharacter(_level, _species, _special, _area, _mintTo);
    }

    function generateConsumable(
        uint256 _amount,
        uint256 _produces,
        uint256 _NFTID
    ) external {
        addressCheck(AA("SETUP"), msg.sender);
        SG(
            "INVENTORY",
            _NFTID,
            d.n2s(_produces),
            GG("INVENTORY", _NFTID, d.n2s(_produces)) + _amount
        ); 
    }

    function generateProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("SETUP"), msg.sender);
        return E().createNewProducable(_level, _produces, _NFTID);
    }

    function generateEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("SETUP"), msg.sender);
        RV().itemSlotCheck(_itemSlot);
        return E().createNewEquippable(_level, _itemSlot, _NFTID);
    }

    function generateBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("SETUP"), msg.sender);
        worldSpaceOccupancyCheck(_area, _location);
        maxAreaSizeCheck(_location);
        return E().createNewBuilding(_area, n2s(_location), _location, _NFTID);
    }

    function replaceCapturedOrKilledCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256) {
        addressCheck(AA("ERC42069HELPER"), msg.sender);
        return E().createNewCharacter(_level, _species, _special, _area, _mintTo);
    }

    function newCharacter(
        address _mintTo
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        return E().createNewCharacter(1, 0, 0, 0, _mintTo);
        // takeCredits(_NFTID, "CHARACTERCOST"); // TAKE NETWORK CURRENCY INSTEAD
    }

    function newConsumable(
        uint256 _amount,
        uint256 _producableProductionType,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        stateCheck(_NFTID, 0);
        consumableBalanceCheck(_NFTID, n2s(_producableProductionType), _amount);
        typeCheck(_NFTID, "_NFTID", 0);
        return E().createNewConsumable(_amount, n2s(_producableProductionType), _producableProductionType, _NFTID);
    }

    function newProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        stateCheck(_NFTID, 0);
        takeCredits(_NFTID, "PRODUCABLECOST");
        return E().createNewProducable(_level, _produces, _NFTID);
    }
    
    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        stateCheck(_NFTID, 0);
        RV().itemSlotCheck(_itemSlot);
        takeCredits(_NFTID, "EQUIPPABLECOST");
        return E().createNewEquippable(_level, _itemSlot, _NFTID);
    }

    function newBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GF(), msg.sender);
        stateCheck(_NFTID, 0);
        worldSpaceOccupancyCheck(_area, _location);
        maxAreaSizeCheck(_location);
        takeCredits(_NFTID, "BUILDINGCOST");
        return E().createNewBuilding(_area, n2s(_location), _location, _NFTID);
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(GF(), msg.sender);
        return E().destroyConsumable(_NFTID, _consumableNFTID);
    }

    function E() internal view returns (ERC42069I) {
        return ERC42069I(AA("ERC42069"));
    }

    function GF() internal view returns (address) {
        return AA("GREATFILTER");
    }

    function RV() internal view returns (ERC42069RevertsI) {
        return ERC42069RevertsI(AA("ERC42069REVERTS"));
    }

    function AA(
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
    }

    function n2s(uint _i) internal view returns (string memory) {
        return d.n2s(_i);
    }

    function SG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue
    ) internal {
            d.setGD(_symbol, _NFTID, _statName, _statValue, "MINTMASTER");
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

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        RV().addressCheck(_target, _sender);
    }

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) internal view {
        RV().typeCheck(_NFTID, _variableName, _type);
    }

    function consumableBalanceCheck(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _amount
    ) internal view {
        RV().consumableBalanceCheck(_NFTID, _producableProductionType, _amount);
    }

    function worldSpaceOccupancyCheck(
        uint256 _area,
        uint256 _location
    ) internal view {
        RV().worldSpaceOccupancyCheck(_area, _location);
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

    function balanceCheck(
        address _from,
        uint256 _amount
    ) internal view {
        RV().balanceCheck(_from, _amount);
    }
}