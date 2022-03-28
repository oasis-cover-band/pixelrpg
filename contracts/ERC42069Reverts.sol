//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error InvalidSender(address _target, address _sender);
error InvalidSenderOr(address _target0, address _target1, address _sender);
error OccupiedWorldSpace(uint256 _targetArea, string _targetPlacementIndex, uint256 _current);
error NotBorderingWorldSpace(uint256 _targetArea, string _targetPlacementIndex, uint256 _current);
error MaxAreaSize(uint256 _targetPlacementIndex);
error SameNFT(uint256 _NFT0ID, uint256 _NFT1ID);
error UintDiffersString(uint256 _uint, string _string);
error EmptyEquipmentSlot(uint256 _current, uint256 _slot, uint256 _NFTID);
error IncorrectEquipmentSlot(uint256 _slot);
error InvalidType(uint256 _NFTID, string _variableName, uint256 _type);
error InvalidTeacher(uint256 _student, uint256 _teacher, uint256 _skill);
error InvalidSpecies(uint256 _NFT0ID, uint256 _NFT1ID, string _variableName);
error InvalidSingleSpecies(uint256 _NFTID, uint256 _requiredSpecies);
error InsufficientBalance(address _from, uint256 _amount);
error InsufficientConsumableBalance(uint256 _NFTID, string _producableProductionType, uint256 _amount);
error InsufficientFreeStatsBalance(uint256 _NFTID, string _statName, uint256 _amount);
error TimerNotReady(uint256 _value, uint256 _mustBeBefore, string _timerName);
error GreaterThanBuildingSize(uint256 _size, uint256 _location);
error InvalidState(uint256 _NFTID, uint256 _actual, uint256 _required);
error InvalidAttackState(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _NFT0HEALTH, uint256 _NFT1HEALTH, uint256 _NFT0BATTLEID, uint256 _NFT1BATTLEID);
error InvalidStartBattleState(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _NFT0HEALTH, uint256 _NFT1HEALTH, uint256 _NFT0BATTLEID, uint256 _NFT1BATTLEID);
error InvalidEndBattleState(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _NFT0HEALTH, uint256 _NFT1HEALTH, uint256 _NFT0BATTLEID, uint256 _NFT1BATTLEID);
error InvalidFleeBattleState(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _NFT0HEALTH, uint256 _NFT1HEALTH, uint256 _NFT0BATTLEID, uint256 _NFT1BATTLEID);
error InvalidCaptureEnemyState(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _NFT0HEALTH, uint256 _NFT1HEALTH, uint256 _NFT0BATTLEID, uint256 _NFT1BATTLEID);
error InvalidQuest(uint256 _NFTID, uint256 _questID);

interface ERC20CreditsI {

    function balanceOf(address account) external view returns (uint256);
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

contract ERC42069Reverts {

    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function AA (
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
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

    function maxBuildingSizeCheck(
        uint256 _buildingNFTID,
        uint256 _location
    ) external view {
        if (_location >= GG("BUILDING", _buildingNFTID, "SIZE")) {
            revert GreaterThanBuildingSize({
                _size: GG("BUILDING", _buildingNFTID, "SIZE"),
                _location: _location
            });
        }
    }

    function borderingWorldSpaceOccupancyCheck(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external view {
        if (
            GG("WORLD", _area, d.n2s(_location - 1)) != _NFTID &&
            GG("WORLD", _area, d.n2s(_location + 1)) != _NFTID &&
            GG("WORLD", _area, d.n2s(_location - GS("AREABLOCKSIZE"))) != _NFTID &&
            GG("WORLD", _area, d.n2s(_location + GS("AREABLOCKSIZE"))) != _NFTID
        ) {
            revert NotBorderingWorldSpace({
                _targetArea: _area,
                _targetPlacementIndex: d.n2s(_location),
                _current: GG("WORLD", _area, d.n2s(_location))
            });
        }
    }

    function maxAreaSizeCheck(
        uint256 _location
    ) external view {
        if (
            _location >= GS("AREASIZE")
        ) {
            revert MaxAreaSize({
                _targetPlacementIndex: _location
            });
        }
    }

    function worldSpaceOccupancyCheck(
        uint256 _area,
        uint256 _location
    ) external view {
        if (GG("WORLD", _area, d.n2s(_location)) != 0) {
            revert OccupiedWorldSpace({
                _targetArea: _area,
                _targetPlacementIndex: d.n2s(_location),
                _current: GG("WORLD", _area, d.n2s(_location))
            });
        }
    }

    function questCheck(
        uint256 _NFTID,
        uint256 _questID
    ) external view {
        if (GG("CHARACTER", _NFTID, "QUESTID") != _questID) {
            revert InvalidQuest({
                _NFTID: _NFTID,
                _questID: _questID
            });
        }
    }

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) public view {
        if (GG("CHARACTER", _NFTID, "STATE") != _requiredState) {
            revert InvalidState({
                _NFTID: _NFTID,
                _actual: GG("CHARACTER", _NFTID, "STATE"),
                _required: _requiredState
            });
        }
    }

    function itemSlotCheck(
        uint256 _equipSlotUint
    ) external view {
        if (_equipSlotUint >= GS("MAXITEMSLOTS")) {
            revert IncorrectEquipmentSlot({
                _slot: _equipSlotUint
            });
        }
    }

    function itemEquippedCheck(
        uint256 _current,
        uint256 _equipSlotUint,
        uint256 _NFTID
    ) external pure {
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
    ) public view {
        if (GG("GENERAL", _NFTID, "TYPE") != _type) {
            revert InvalidType({
                _NFTID: _NFTID,
                _variableName: _variableName,
                _type: _type
            });
        }
    }

    function singleSpeciesCheck(
        uint256 _NFTID,
        uint256 _requiredSpecies
    ) external view {
        if (GG("CHARACTER", _NFTID, "SPECIES") != _requiredSpecies) {
            revert InvalidSingleSpecies({
                _NFTID: _NFTID,
                _requiredSpecies: _requiredSpecies
            });
        }
    }

    function speciesCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) external view {
        if (GG("CHARACTER", _NFT0ID, "SPECIES") != GG("CHARACTER", _NFT1ID, "SPECIES")) {
            revert InvalidSpecies({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _variableName: _variableName
            });
        }
    }

    function companionCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) external view {
        if (GG("CHARACTER", _NFT0ID, "SPECIES") != 0 ||
        GG("CHARACTER", _NFT1ID, "SPECIES") == 0) {
            revert InvalidSpecies({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _variableName: _variableName
            });
        }
    }

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) external pure {
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

    function differsCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external pure {
        if ( _NFT0ID == _NFT1ID) {
            revert SameNFT({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID
            });
        }
    }

    function teachCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _skill
    ) external view {
        // IF NOT LAST TAUGHT BY THIS NFTNPC
        // IF THIS NFT IS AN NPC (SPECIAL === 1)
        // IF THIS NPC CAN TEACH THIS SKILL (ID % _skill)
        if (
            GG("CHARACTER", _NFT1ID, "LASTTAUGHT") == _NFT0ID ||
            GG("GENERAL", _NFT1ID, "SPECIAL") != 1 ||
            _NFT1ID % _skill != 0
        ) {
            revert InvalidTeacher({
                _student: _NFT0ID,
                _teacher: _NFT1ID,
                _skill: _skill
            });
        }
    }

    function balanceCheck(
        address _from,
        uint256 _amount
    ) external view {
        if (
            ERC20CreditsI(AA("ERC20CREDITS")).balanceOf(_from) < _amount) {
            revert InsufficientBalance({
                _from: _from,
                _amount: _amount
            });
        }
    }

    function attackChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view {
        stateCheck(_NFT0ID, 420);
        stateCheck(_NFT1ID, 420);
        if (
            GG("CHARACTER", _NFT0ID, "BATTLEID") !=
            GG("CHARACTER", _NFT1ID, "BATTLEID") ||
            GG("CHARACTER", _NFT0ID, "HEALTH") == 0 ||
            GG("CHARACTER", _NFT1ID, "HEALTH") == 0
        ) {
            revert InvalidAttackState({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _NFT0HEALTH: GG("CHARACTER", _NFT0ID, "HEALTH"),
                _NFT1HEALTH: GG("CHARACTER", _NFT1ID, "HEALTH"),
                _NFT0BATTLEID: GG("CHARACTER", _NFT0ID, "BATTLEID"),
                _NFT1BATTLEID: GG("CHARACTER", _NFT1ID, "BATTLEID")
            });
        }
    }

    function startBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view {
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 0);
        stateCheck(_NFT1ID, 0);
        if (
            GG("CHARACTER", _NFT0ID, "BATTLEID") != 0 ||
            GG("CHARACTER", _NFT1ID, "BATTLEID") != 0 ||
            GG("CHARACTER", _NFT0ID, "HEALTH") == 0 ||
            GG("CHARACTER", _NFT1ID, "HEALTH") == 0 ||
            _NFT0ID == _NFT1ID
        ) {
            revert InvalidStartBattleState({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _NFT0HEALTH: GG("CHARACTER", _NFT0ID, "HEALTH"),
                _NFT1HEALTH: GG("CHARACTER", _NFT1ID, "HEALTH"),
                _NFT0BATTLEID: GG("CHARACTER", _NFT0ID, "BATTLEID"),
                _NFT1BATTLEID: GG("CHARACTER", _NFT1ID, "BATTLEID")
            });
        }
    }

    function endBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view {
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 420);
        stateCheck(_NFT1ID, 420);
        if (
            GG("CHARACTER", _NFT0ID, "BATTLEID") !=
            GG("CHARACTER", _NFT1ID, "BATTLEID") ||
            GG("CHARACTER", _NFT1ID, "HEALTH") != 0
        ) {
            revert InvalidEndBattleState({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _NFT0HEALTH: GG("CHARACTER", _NFT0ID, "HEALTH"),
                _NFT1HEALTH: GG("CHARACTER", _NFT1ID, "HEALTH"),
                _NFT0BATTLEID: GG("CHARACTER", _NFT0ID, "BATTLEID"),
                _NFT1BATTLEID: GG("CHARACTER", _NFT1ID, "BATTLEID")
            });
        }
    }

    function fleeBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view {
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 420);
        stateCheck(_NFT1ID, 420);
        if (
            GG("CHARACTER", _NFT0ID, "BATTLEID") !=
            GG("CHARACTER", _NFT1ID, "BATTLEID")
        ) {
            revert InvalidFleeBattleState({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _NFT0HEALTH: GG("CHARACTER", _NFT0ID, "HEALTH"),
                _NFT1HEALTH: GG("CHARACTER", _NFT1ID, "HEALTH"),
                _NFT0BATTLEID: GG("CHARACTER", _NFT0ID, "BATTLEID"),
                _NFT1BATTLEID: GG("CHARACTER", _NFT1ID, "BATTLEID")
            });
        }
    }

    function captureEnemyChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view {
        typeCheck(_NFT0ID, "_NFT0ID", 0);
        typeCheck(_NFT1ID, "_NFT1ID", 0);
        stateCheck(_NFT0ID, 420);
        stateCheck(_NFT1ID, 420);
        if (
            GG("CHARACTER", _NFT0ID, "BATTLEID") !=
            GG("CHARACTER", _NFT1ID, "BATTLEID") ||
            GG("CHARACTER", _NFT1ID, "HEALTH") != 0 ||
            GG("CHARACTER", _NFT1ID, "SPECIES") == 0 ||
            GG("GENERAL", _NFT1ID, "SPECIAL") == 0 ||
            GG("CHARACTER", _NFT0ID, "SPECIES") != 0
        ) {
            revert InvalidCaptureEnemyState({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _NFT0HEALTH: GG("CHARACTER", _NFT0ID, "HEALTH"),
                _NFT1HEALTH: GG("CHARACTER", _NFT1ID, "HEALTH"),
                _NFT0BATTLEID: GG("CHARACTER", _NFT0ID, "BATTLEID"),
                _NFT1BATTLEID: GG("CHARACTER", _NFT1ID, "BATTLEID")
            });
        }
    }

    function consumableBalanceCheck(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _amount
    ) external view {
        if (
            GG("INVENTORY", _NFTID, _producableProductionType) < _amount) {
            revert InsufficientConsumableBalance({
                _NFTID: _NFTID,
                _producableProductionType: _producableProductionType,
                _amount: _amount
            });
        }
    }

    function freeStatsBalanceCheck(
        uint256 _NFTID,
        uint256 _amount
    ) external view {
        if (
            GG("CHARACTER", _NFTID, "FREESTATS") < _amount) {
            revert InsufficientFreeStatsBalance({
                _NFTID: _NFTID,
                _statName: "FREESTATS",
                _amount: _amount
            });
        }
    }

    function addressCheck(
        address _target,
        address _sender
    ) external pure {
        if (_target != _sender) {
            revert InvalidSender({
                _target: _target,
                _sender: _sender
            });
        }
    }

    function addressCheckOr(
        address _target0,
        address _target1,
        address _sender
    ) external pure {
        if (_sender != _target0 && _sender != _target1) {
            revert InvalidSenderOr({
                _target0: _target0,
                _target1: _target1,
                _sender: _sender
            });
        }
    }
}