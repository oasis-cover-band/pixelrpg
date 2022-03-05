//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error InvalidSender(address _target, address _sender, string _checkName);

interface GameMaster {
    
    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external;

    function newBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external;
    
    function equip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external;

    function unequip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _NFTID
    ) external;

    function produce(
        uint256 _NFTID,
        uint256 _producableNFTID
    ) external;
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
}
interface ERC42069 {

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);   
}

contract GreatFilter {

    ERC42069Data d;

    constructor(
        address _dataAddress
    ) {
        d = ERC42069Data(_dataAddress);
    }

    function produce(
        uint256 _NFTID,
        uint256 _producableNFTID
    ) external {
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(GG("PRODUCABLE", _producableNFTID, "PLACEDIN")), msg.sender, "OWNTYPE5");
        GameMaster(AA("GAMEMASTER")).produce(
            _NFTID,
            _producableNFTID
        );
    }
    
    function buyEquippable(
        uint256 _itemSlot,
        uint256 _NFTID
    ) external {
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        GameMaster(AA("GAMEMASTER")).newEquippable(
            1,
            _itemSlot,
            _NFTID
        );
    }

    function buyBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external {
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        GameMaster(AA("GAMEMASTER")).newBuilding(
            _area,
            _location,
            _locationUint,
            _NFTID
        );
    }
    
    function equip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external {
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_equipNFTID), msg.sender, "OWNTYPE3");
        GameMaster(AA("GAMEMASTER")).equip(
            _equipSlotUint,
            _equipSlot,
            _equipNFTID,
            _NFTID
        );
    }

    function unequip(
        uint256 _equipSlotUint,
        string memory _equipSlot,
        uint256 _NFTID
    ) public {
        addressCheck(ERC42069(AA("ERC42069")).ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        GameMaster(AA("GAMEMASTER")).unequip(
            _equipSlotUint,
            _equipSlot,
            _NFTID
        );
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
            d.setGD(_symbol, _NFTID, _statName, _statValue, "GREATFILTER");
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
        address _sender,
        string memory _checkName
    ) internal view {
        if (
            _target != _sender &&
            AA("WEB3BYPASS") != _sender) {
            revert InvalidSender({
                _target: _target,
                _sender: _sender,
                _checkName: _checkName
            });
        }
    }
}
