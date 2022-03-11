//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error OccupiedWorldSpace(uint256 _targetArea, string _targetPlacementIndex, uint256 _current);
error NotBorderingWorldSpace(uint256 _targetArea, string _targetPlacementIndex, uint256 _current);
error MaxAreaSize(uint256 _targetPlacementIndex);
error SameNFT(uint256 _NFT0ID, uint256 _NFT1ID);
error InvalidSender(address _target, address _sender);
error UintDiffersString(uint256 _uint, string _string);
error EmptyEquipmentSlot(uint256 _current, uint256 _slot, uint256 _NFTID);
error IncorrectEquipmentSlot(uint256 _slot);
error InvalidType(uint256 _NFTID, string _variableName, uint256 _type);
error InvalidSpecies(uint256 _NFT0ID, uint256 _NFT1ID, string _variableName);
error InsufficientBalance(address _from, uint256 _amount);
error InsufficientConsumableBalance(uint256 _NFTID, string _producableProductionType, uint256 _amount);
error InsufficientFreeStatsBalance(uint256 _NFTID, string _statName, uint256 _amount);
error TimerNotReady(uint256 _value, uint256 _mustBeBefore, string _timerName);
error GreaterThanBuildingSize(uint256 _size, uint256 _location);
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
    )
        {
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

    function speciesCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        string memory _variableName
    ) public view {
        if (GG("CHARACTER", _NFT0ID, "SPECIES") != GG("CHARACTER", _NFT1ID, "SPECIES")) {
            revert InvalidSpecies({
                _NFT0ID: _NFT0ID,
                _NFT1ID: _NFT1ID,
                _variableName: _variableName
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

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) public pure {
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
}