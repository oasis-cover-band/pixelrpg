//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

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
}
interface ERC42069HelperI {
    
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

    function gainExperience(
        uint256 _amount,
        uint256 _NFTID
    ) external;

    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _createdNFTID
    ) external;

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _createdNFTID
    ) external;

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        uint256 _createdNFTID
    ) external;

    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _createdNFTID
    ) external;

    function createNewProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _createdNFTID
    ) external;

    function createNewConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID,
        uint256 _createdNFTID
    ) external;
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external;
}
interface ERC42069RevertsI {

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) external view;

    function addressCheck(
        address _target,
        address _sender
    ) external pure;


    function addressCheckOr(
        address _target0,
        address _target1,
        address _sender
    ) external pure;
}

contract ERC42069 is ERC721 {

    ERC42069DataI d;
    uint256 public count;
    constructor(
        string memory _typeName,
        string memory _typeSymbol,
        address _dataAddress
    ) ERC721(_typeName, _typeSymbol) {
        d = ERC42069DataI(_dataAddress);
        count = 1;
        console.log("Created ERC42069 Factory: NAME:'%s' SYMBOL:'%s' D:'%s'", _typeName, _typeSymbol, _dataAddress);
    }
    
    function exists(uint256 tokenId) external view virtual returns (bool) {
        return _exists(tokenId);
    }
    
    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069HelperI(AA("ERC42069HELPER")).consume(
            _NFTID,
            _consumingNFTID,
            _producableProductionType,
            _producableProductionTypeUint,
            _amount
        );
        console.log("Created ERC42069 Token (Character): CONSUMED:'%s' AMOUNT: '%s' ID:'%s'", _producableProductionType, _amount, _NFTID);
    }

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external {
        addressCheckOr(AA("GAMEMASTER"), AA("EXPANSION0MASTER"), msg.sender);
        internalGameTransfer(_NFTID, _to);
    }

    function internalGameTransfer(
        uint256 _NFTID,
        address _to
    ) internal {
        console.log(ownerOf(_NFTID));
        _transfer(
        ownerOf(_NFTID),
        _to,
        _NFTID);
        console.log("Game Transferred ERC42069: NFTID:'%s' TO:'%s'", _NFTID, _to);
    }

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256) {
        addressCheck(AA("MINTMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).createNewCharacter(
            _level,
            _species,
            _special,
            _area,
            c
        );
        _safeMint(_mintTo, c);
        count = c + 1;
        
        SGN("GENERAL", c, "NAME", NameGeneratorI(d.getAA("NAMEGENERATOR")).getRandomName());
        console.log("Created ERC42069 Token (Character): Sent:'%s' ID:'%s'", _mintTo, c);
        return c;
    }

    function gainExperience(
        uint256 _amount,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender); // SHOULD ONLY BE CALLED FROM BATTLE/QUESTER?
        ERC42069HelperI(AA("ERC42069HELPER")).gainExperience(
            _amount,
            _NFTID
        );
        console.log("ERC42069 gained Experience (Character): AMOUNT:'%s' ID:'%s'", _amount, _NFTID);
    }

    function evolve(
        uint256 _NFTID
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        if (GG("CHARACTER", _NFTID, "LEVEL") >= 66) {
            SG("CHARACTER", _NFTID, "EVOLUTION", 2);    
        } else if (GG("CHARACTER", _NFTID, "LEVEL") >= 33) {
            SG("CHARACTER", _NFTID, "EVOLUTION", 1);    
        }
    }

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069HelperI(AA("ERC42069HELPER")).giveStat(
            _NFTID,
            _amount,
            _statName
        );
        console.log("ERC42069 gained Stat (Character): AMOUNT:'%s' ID:'%s' STATNAME:'%s'", _amount, _NFTID, _statName);
    }

    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).breedTwoCharacters(
            _NFT0ID,
            _NFT1ID,
            c
        );
        _safeMint(ownerOf(_NFT0ID), c);
        count = c + 1;
        SGN("GENERAL", c, "NAME", NameGeneratorI(d.getAA("NAMEGENERATOR")).getRandomName());
        console.log("Breeded Two ERC42069 Token (Character): NFT0ID:'%s' NFT1ID:'%s' NFTID:'%s'", _NFT0ID, _NFT1ID, c);
        return c;
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).mergeTwoCharacters(
            _NFT0ID,
            _NFT1ID,
            c
        );
        _safeMint(ownerOf(_NFT0ID), c);
        internalGameTransfer(_NFT0ID, address(this));
        internalGameTransfer(_NFT1ID, address(this));
        count = c + 1;
        SGN("GENERAL", c, "NAME", NameGeneratorI(d.getAA("NAMEGENERATOR")).getRandomName());
        console.log("Merged Two ERC42069 Token (Character): NFT0ID:'%s' NFT1ID:'%s' NFTID:'%s'", _NFT0ID, _NFT1ID, c);
        return c;
    }

    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("MINTMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).createNewEquippable(
            _level,
            _equipSlot,
            c
        );
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
        addressCheck(AA("MINTMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).createNewProducable(
            _level,
            _produces,
            c
        );
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Producable): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        return c;
    }

    function createNewConsumable(
        uint256 _amount,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("MINTMASTER"), msg.sender);
        uint256 c = count;
        ERC42069HelperI(AA("ERC42069HELPER")).createNewConsumable(
            _amount,
            _producableProductionType,
            _producableProductionTypeUint,
            _NFTID,
            c
        );
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Consumable): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        return c;
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(AA("MINTMASTER"), msg.sender);
        ERC42069HelperI(AA("ERC42069HELPER")).destroyConsumable(
            _NFTID,
            _consumableNFTID
        );
        console.log("Destroyed ERC42069 Token (Consumable): AMOUNT:'%s' SentNFTID:'%s' ID:'%s'", GG("CONSUMABLE", _consumableNFTID, "AMOUNT"), _NFTID, _consumableNFTID);
    }

    function AA(
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

    function SGN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue
    ) internal {
            d.setGDN(_symbol, _NFTID, _statName, _statValue, "ERC42069");
    }

    function GS (
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

    function RV() internal view returns (ERC42069RevertsI) {
        return ERC42069RevertsI(AA("ERC42069REVERTS"));
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        RV().addressCheck(_target, _sender);
    }

    function addressCheckOr(
        address _target0,
        address _target1,
        address _sender
    ) internal view {
        RV().addressCheckOr(_target0, _target1, _sender);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        RV().stateCheck(tokenId, 0);
    }
}
