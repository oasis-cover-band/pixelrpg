//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error InvalidERC42069Sender(address _target, address _sender);

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

    function r() external view returns (uint256);

    function getGS(string memory _setting) external view returns (uint256);

    function getAA(string memory _name) external view returns (address);

    function n2s(uint _i) external pure returns (string memory);
}
interface ERC42069Helper {
    
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external returns (uint256);

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external returns (uint256);

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

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _createdNFTID
    ) external;
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

    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 producableNFTID = ERC42069Helper(AA("ERC42069HELPER")).placeProducable(_NFTID, _location, _buildingNFTID);
        if(producableNFTID > 0) {
            internalGameTransfer(producableNFTID, ownerOf(_buildingNFTID));
        }
        internalGameTransfer(_NFTID, address(this));
    }

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        internalGameTransfer(ERC42069Helper(AA("ERC42069HELPER")).retrieveFromBuilding(_location, _NFTID), ownerOf(_NFTID));
    }
    
    function consume(
        uint256 _NFTID,
        string memory _producableProductionType,
        uint256 _producableProductionTypeUint,
        uint256 _amount
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069Helper(AA("ERC42069HELPER")).consume(
            _NFTID,
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
        console.log("Game Transferred ERC42069: NFTID:'%s' TO:'%s'", _NFTID, _to);
    }

    function createNewCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).createNewCharacter(
            _level,
            _species,
            _special,
            _area,
            c
        );
        _safeMint(_mintTo, c);
        count = c + 1;
        console.log("Created ERC42069 Token (Character): Sent:'%s' ID:'%s'", _mintTo, c);
        return c;
    }

    function gainExperience(
        uint256 _amount,
        uint256 _NFTID
    ) external {
        addressCheck(AA("ERC42069ACTIONS"), msg.sender); // SHOULD ONLY BE CALLED FROM BATTLE/QUESTER?
        ERC42069Helper(AA("ERC42069HELPER")).gainExperience(
            _amount,
            _NFTID
        );
        console.log("ERC42069 gained Experience (Character): AMOUNT:'%s' ID:'%s'", _amount, _NFTID);
    }

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069Helper(AA("ERC42069HELPER")).giveStat(
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
        ERC42069Helper(AA("ERC42069HELPER")).breedTwoCharacters(
            _NFT0ID,
            _NFT1ID,
            c
        );
        _safeMint(ownerOf(_NFT0ID), c);
        count = c + 1;
        console.log("Breeded Two ERC42069 Token (Character): NFT0ID:'%s' NFT1ID:'%s' NFTID:'%s'", _NFT0ID, _NFT1ID, c);
        return c;
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).mergeTwoCharacters(
            _NFT0ID,
            _NFT1ID,
            c
        );
        _safeMint(ownerOf(_NFT0ID), c);
        internalGameTransfer(_NFT0ID, address(this));
        internalGameTransfer(_NFT1ID, address(this));
        count = c + 1;
        console.log("Merged Two ERC42069 Token (Character): NFT0ID:'%s' NFT1ID:'%s' NFTID:'%s'", _NFT0ID, _NFT1ID, c);
        return c;
    }

    function createNewEquippable(
        uint256 _level,
        uint256 _equipSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).createNewEquippable(
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
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).createNewProducable(
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
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).createNewConsumable(
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
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069Helper(AA("ERC42069HELPER")).destroyConsumable(
            _NFTID,
            _consumableNFTID
        );
        console.log("Destroyed ERC42069 Token (Consumable): AMOUNT:'%s' SentNFTID:'%s' ID:'%s'", GG("CONSUMABLE", _consumableNFTID, "AMOUNT"), _NFTID, _consumableNFTID);
    }

    function createNewBuilding(
        uint256 _area,
        string memory _location,
        uint256 _locationUint,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        uint256 c = count;
        ERC42069Helper(AA("ERC42069HELPER")).createNewConsumable(
            _area,
            _location,
            _locationUint,
            _NFTID,
            c
        );
        _safeMint(ownerOf(_NFTID), c);
        count = c + 1;
        console.log("Created ERC42069 Token (Building): Sent:'%s' SentNFTID:'%s' ID:'%s'", ownerOf(_NFTID), _NFTID, c);
        console.log("Building '%s' placed in Area '%s' Location '%s", c, _area, _location);
        return c;
    }

    function expandBuilding(
        uint256 _NFTID,
        string memory _location,
        uint256 _up
    ) external {
        addressCheck(AA("GAMEMASTER"), msg.sender);
        ERC42069Helper(AA("ERC42069HELPER")).expandBuilding(
        _NFTID,
        _location,
        _up
        );
        console.log("Expanded ERC42069 Token (Building): ID:'%s' INDEX:'%s' UP?:'%s'", _NFTID, _location, _up);
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
    ) internal pure {
        if (_target != _sender) {
            revert InvalidERC42069Sender({
                _target: _target,
                _sender: _sender
            });
        }
    }
}
