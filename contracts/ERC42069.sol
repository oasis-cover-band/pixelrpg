//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error InvalidSender(address _target, address _sender);

interface ERC42069Data {

    function setGD(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue,
        string memory _msgSender
    ) external;

    function r() external view returns (uint256);

    function getGS(string memory _setting) external view returns (uint256);

    function getAA(string memory _name) external view returns (address);
}

contract ERC42069 is ERC721 {

    ERC42069Data d;
    uint256 public count;
    constructor(
        string memory _typeName,
        string memory _typeSymbol,
        address _dataAddress
    ) ERC721(_typeName, _typeSymbol)
        {
        d = ERC42069Data(_dataAddress);
        count = 1;
        console.log("Created ERC42069 Factory: NAME:'%s' SYMBOL:'%s' D:'%s'", _typeName, _typeSymbol, _dataAddress);
    }

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        internalGameTransfer(_NFTID, _to);
    }

    function internalGameTransfer(
        uint256 _NFTID,
        address _to
    ) internal {
        _transfer(
        ownerOf(_NFTID),
        _to,
        _NFTID);
        console.log("GAME TRANSFERRED ERC42069: F:'%s' T:'%s'", _NFTID, _to);
    }

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 r = d.r();
        uint256 c = count;
        SG("CHARACTER", c, "HEALTH", 10 + _level * (r % GS("STARTINGHEALTH")));
        SG("CHARACTER", c, "MAXHEALTH", 10 + _level * (r % GS("STARTINGHEALTH")));
        SG("CHARACTER", c, "ENERGY", 10 + _level * (r % GS("STARTINGENERGY")));
        SG("CHARACTER", c, "MAXENERGY", 10 + _level * (r % GS("STARTINGENERGY")));
        SG("CHARACTER", c, "STRENGTH", 1 + _level * (r + 312932131931931293 % GS("STARTINGSTATS")));
        SG("CHARACTER", c, "DEXTERITY", 1 + _level * (r + 1993381931931293 % GS("STARTINGSTATS")));
        SG("CHARACTER", c, "INTELLIGENCE", 1 + _level * (r + 9555551931931293 % GS("STARTINGSTATS")));
        SG("CHARACTER", c, "CHARISMA", 1 + _level * (r + 74499292929129 % GS("STARTINGSTATS")));
        SG("CHARACTER", c, "NEXTBREEDING", block.timestamp + GS("BREEDINGRESET"));
        SG("CHARACTER", c, "FREESTATS", r % GS("STARTINGSTATS") + 3);
        SG("CHARACTER", c, "EXPERIENCE", 0);
        SG("CHARACTER", c, "LEVEL", _level);
        SG("CHARACTER", c, "SPECIES", _species);
        // SG("CHARACTER", c, "0", 0);
        // SG("CHARACTER", c, "1", 0);
        // SG("CHARACTER", c, "2", 0);
        // SG("CHARACTER", c, "3", 0);
        // SG("CHARACTER", c, "4", 0);
        // SG("CHARACTER", c, "5", 0);
        SG("GENERAL", c, "DNA", r);
        SG("GENERAL", c, "TYPE", 0);
        SG("GENERAL", c, "SPECIAL", _special);
        SG("GENERAL", c, "AREA", _area);
        _safeMint(_mintTo, c);
        count = c + 1;
        console.log("Created ERC42069 Token (Character): Sent:'%s' ID:'%s'", _mintTo, c);
        return c;
    }

    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 r = d.r();
        uint256 c = count;
        SG("EQUIPPABLE", c, "HEALTHBOOST", 10 + _level * (r % GS("MAXITEMHEALTH")));
        SG("EQUIPPABLE", c, "ENERGYBOOST", 10 + _level * (r % GS("MAXITEMENERGY")));
        SG("EQUIPPABLE", c, "STRENGTHBOOST", 1 * _level * ((r + 49438249242378) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", c, "DEXTERITYBOOST", 1 * _level * ((r + 9448242378) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", c, "INTELLIGENCEBOOST", 1 * _level * ((r + 6945932378) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", c, "CHARISMABOOST", 1 * _level * ((r + 189348242378) % GS("MAXITEMSTATS")));
        SG("EQUIPPABLE", c, "EQUIPSLOT", _equipSlot);
        // SG("EQUIPPABLE", c, "EQUIPPEDBY", 0); 
        SG("GENERAL", c, "DNA", r);
        SG("GENERAL", c, "TYPE", 3);
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Item): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        console.log("Item '%s' fits in Item Slot '%s'", c, _equipSlot);
        return c;
    }

    function createNewProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 r = d.r();
        uint256 c = count;
        SG("PRODUCABLE", c, "PRODUCES", _produces);
        SG("PRODUCABLE", c, "PRODUCTION", 1 + _level * ((r + 49438249242378) % GS("MAXPRODUCTION")));
        SG("PRODUCABLE", c, "NEXTPRODUCTION", block.timestamp + GS("PRODUCTIONRESET")); 
        // SG("PRODUCABLE", c, "PLACEDIN", 0);
        SG("GENERAL", c, "DNA", r);
        SG("GENERAL", c, "TYPE", 4);
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Producable): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        return c;
    }

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 r = d.r();
        uint256 c = count;
        SG("BUILDING", c, "SIZEX", 1);
        SG("BUILDING", c, "SIZEY", 1);
        SG("BUILDING", c, "SIZEZ", 1);
        SG("BUILDING", c, "LOCATION", _locationUint);
        // SG("BUILDING", c, "0", 0);
        SG("GENERAL", c, "TYPE", 5);
        SG("GENERAL", c, "DNA", r);
        SG("GENERAL", c, "AREA", _area);
        SG("WORLD", _area, _location, c);
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Building): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        console.log("Building '%s' placed in Area '%s' Location '%s", c, _area, _location);
        return c;
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
            d.setGD(_symbol, _NFTID, _statName, _statValue, "ERC42069");
    }

    function GS (
        string memory _setting
    ) internal view returns (uint256) {
            return d.getGS(_setting);
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
}
