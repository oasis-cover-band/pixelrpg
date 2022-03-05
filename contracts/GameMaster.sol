//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error OccupiedWorldSpace(uint256 _targetArea, string _targetPlacementIndex, uint256 _current);
error InvalidSender(address _target, address _sender);
error UintDiffersString(uint256 _uint, string _string);
error EmptyEquipmentSlot(uint256 _current, uint256 _slot, uint256 _NFTID);
error InvalidType(uint256 _NFTID, string _variableName, uint256 _type);
error InsufficientBalance(address _from, uint256 _amount);
error TimerNotReady(uint256 _value, uint256 _mustBeBefore, string _timerName);

interface ERC42069 {

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external;

    function createNewEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external;

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external;

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external;

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);
}
interface ERC20Credits {

    function mintCoins(uint256 _NFTID, uint256 _amount) external;

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
contract GameMaster {

    ERC42069Data d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069Data(_dataAddress);
    }

    function newCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        ERC42069(AA("ERC42069")).createNewCharacter(_level, _species, _special, _area, _mintTo);
    }
    
    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        ERC42069(AA("ERC42069")).createNewEquippable(_level, _itemSlot, _NFTID);
        balanceCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), GS("ITEMCOST"));
        ERC20Credits(AA("ERC20CREDITS")).burnCoins(_NFTID, 3 * (GS("ITEMCOST") / 4));
        ERC20Credits(AA("ERC20CREDITS")).gameTransferFrom(ERC42069(AA("ERC42069")).ownerOf(_NFTID), AA("TREASURY"), GS("ITEMCOST") / 4);
    }

    function newBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        worldSpaceOccupancyCheck(_area, _location);
        sameNumber(_locationUint, _location);
        ERC42069(AA("ERC42069")).createNewBuilding(_area, _location, _locationUint, _NFTID);
        balanceCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), GS("BUILDINGCOST"));
        ERC20Credits(AA("ERC20CREDITS")).burnCoins(_NFTID, 3 * (GS("BUILDINGCOST") / 4));
        ERC20Credits(AA("ERC20CREDITS")).gameTransferFrom(ERC42069(AA("ERC42069")).ownerOf(_NFTID), AA("TREASURY"), GS("BUILDINGCOST") / 4);
    }
    
    function equip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        sameNumber(_equipSlotUint, _equipSlot);
        typeCheck(_NFTID, "_NFTID", 0);
        typeCheck(_equipNFTID, "_equipNFTID", 3);
        if (GG("CHARACTER", _NFTID, _equipSlot) != 0) {
            unequip(_equipSlotUint, _equipSlot, _NFTID);
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

    function unequip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _NFTID
    ) public {
        addressCheck(AA("GREATFILTER"), msg.sender);
        sameNumber(_equipSlotUint, _equipSlot);
        typeCheck(_NFTID, "_NFTID", 0);
        itemEquipped(GG("CHARACTER", _NFTID, _equipSlot), _equipSlotUint, _NFTID);
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

    function sameNumber(
        uint256 _locationUint,
        string memory _location
    ) internal view {
        if (_locationUint != d.s2n(_location)) {
            revert UintDiffersString({
                _uint: _locationUint,
                _string: _location
            });
        }
    }

    function worldSpaceOccupancyCheck(
        uint256 _area,
        string memory _location
    ) internal view {
        if (GG("WORLD", _area, _location) != 0) {
            revert OccupiedWorldSpace({
                _targetArea: _area,
                _targetPlacementIndex: _location,
                _current: GG("WORLD", _area, _location)
            });
        }
    }

    function itemEquipped(
        uint256 _current,
        uint256 _equipSlotUint,
        uint256 _NFTID
    ) internal pure {
        if (_current == 0) {
            revert EmptyEquipmentSlot({
                _current: _current,
                _slot: _equipSlotUint,
                _NFTID: _NFTID
            });
        }
    }

    function typeCheck(
        uint256 _NFTID,
        string memory _variableName,
        uint256 _type
    ) internal view {
        if (GG("GENERAL", _NFTID, "TYPE") != _type) {
            revert InvalidType({
                _NFTID: _NFTID,
                _variableName: _variableName,
                _type: _type
            });
        }
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal pure {
        if (_target != _sender) {
            revert InvalidSender({
                _target: _target,
                _sender: _sender
            });
        }
    }

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) internal pure {
        if (
            _value >= _mustBeBefore
        ) {
            revert TimerNotReady({
                _value: _value,
                _mustBeBefore: _mustBeBefore,
                _timerName: _timerName
            });
        }
    }

    function balanceCheck(
        address _from,
        uint256 _amount
    ) internal view {
        if (
            ERC20Credits(AA("ERC20CREDITS")).balanceOf(_from) < _amount) {
            revert InsufficientBalance({
                _from: _from,
                _amount: _amount
            });
        }
    }
}
