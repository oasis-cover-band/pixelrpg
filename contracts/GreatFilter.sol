//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

error InvalidFilterSender(address _target, address _sender, string _checkName);

interface ERC20CreditsI {
    
    function mintCoins(
        uint256 _NFTID,
        uint256 _amount
    ) external;
}
interface Expansion0MasterI {

    function startQuest(
        uint256 _NFTID,
        uint256 _questID
    ) external;

    function finishQuest(
        uint256 _NFTID,
        uint256 _questID
    ) external;

    function rename(
        uint256 _NFTID,
        string memory _newName
    ) external returns (string memory);
    
    function attackEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256, uint256);

    function startBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external;

    function endBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external;

    function fleeBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external;

    function captureEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external;
}
interface MintMasterI {

    function newCharacter(
        address _mintTo
    ) external returns (uint256);
    
    function newProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256);

    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256);

    function newBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external returns (uint256);
}
interface GameMasterI {

    function evolve(
        uint256 _NFTID
    ) external;
    
    function setCompanion(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external;

    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        uint256 _producableProductionType,
        uint256 _amount
    ) external;

    function newCharacter(
        address _mintTo
    ) external returns (uint256);
    
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external;

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
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
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external;
    
    function newProducable(
        uint256 _level,
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256);

    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256);

    function newBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external returns (uint256);
    
    function equip(
        uint256 _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external;

    function unequip(
        uint256 _equipSlot,
        uint256 _NFTID
    ) external;

    function produce(
        uint256 _NFTID,
        uint256 _producableNFTID
    ) external;
}
interface ERC42069DataI {

    function getGS(string memory _setting) external view returns (uint256);
    
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
}
interface ERC42069I {

    function gainExperience(
        uint256 _amount,
        uint256 _NFTID
    ) external;

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);   
}

contract GreatFilter {
    event Attack(uint256 _NFT0Dmg, uint256 _NFT1Dmg);
    event NewNFT(uint256 _NFTID);
    event NewNFTName(string _newName);

    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function startQuest(
        uint256 _NFTID,
        uint256 _questID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "STARTQUEST");
        E0M().startQuest(_NFTID, _questID);
    }

    function finishQuest(
        uint256 _NFTID,
        uint256 _questID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "ENDQUEST");
        giveQuestReward(_NFTID, _questID);
        E0M().finishQuest(_NFTID, _questID);
    }

    function attackEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256, uint256) {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        (uint256 _NFT0Dmg, uint256 _NFT1Dmg) = E0M().attackEnemy(_NFT0ID, _NFT1ID);
        emit Attack(_NFT0Dmg, _NFT1Dmg);
        return (_NFT0Dmg, _NFT1Dmg);
    }

    function startBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        E0M().startBattle(_NFT0ID, _NFT1ID);
    }

    function endBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        giveFightReward(_NFT0ID, _NFT1ID);
        E0M().endBattle(_NFT0ID, _NFT1ID);
    }

    function fleeBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        E0M().fleeBattle(_NFT0ID, _NFT1ID);
    }

    function captureEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        giveFightReward(_NFT0ID, _NFT1ID);
        E0M().captureEnemy(_NFT0ID, _NFT1ID);
    }

    function giveQuestReward(
        uint256 _NFTID,
        uint256 _questID
    ) internal {
        ERC42069I(AA("ERC42069")).gainExperience(_NFTID, (d.r() + 3921) % ((_questID * GS("QUESTREWARD")) + 1));
        ERC20CreditsI(AA("ERC20CREDITS")).mintCoins(_NFTID,  d.r() % ((_questID * GS("QUESTREWARD")) + 1));
    }

    function giveFightReward(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal {
        if (GG("GENERAL", _NFT1ID, "SPECIAL") == 0) {
            ERC42069I(AA("ERC42069")).gainExperience(_NFT0ID, (d.r() + 3921) % ((GG("CHARACTER", _NFT1ID, "LEVEL") / 2) + 1));
        } else {
            ERC42069I(AA("ERC42069")).gainExperience(_NFT0ID, (d.r() + 3921) % (GG("CHARACTER", _NFT1ID, "LEVEL") + 1));
            ERC20CreditsI(AA("ERC20CREDITS")).mintCoins(_NFT0ID,  d.r() % (GG("CHARACTER", _NFT1ID, "LEVEL") + 1));
        }
    }

    function evolve(
        uint256 _NFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "EVOLVE");
        GM().evolve(_NFTID);
    }

    function setCompanion(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        addressCheck(E().ownerOf(_NFT1ID), msg.sender, "OWNNFT1");
        GM().setCompanion(_NFT0ID, _NFT1ID);
    }
    
    function placeProducable(
        uint256 _NFTID,
        string memory _location,
        uint256 _buildingNFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNNFT");
        addressCheck(E().ownerOf(_buildingNFTID), msg.sender, "OWNBUILDINGNFT");
        GM().placeProducable(_NFTID, _location, _buildingNFTID);
    }

    function retrieveFromBuilding(
        string memory _location,
        uint256 _NFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNNFT");
        GM().retrieveFromBuilding(_location, _NFTID);
    }

    function consume(
        uint256 _NFTID,
        uint256 _consumingNFTID,
        uint256 _producableProductionType,
        uint256 _amount
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNNFT");
        addressCheck(E().ownerOf(_consumingNFTID), msg.sender, "OWNNFT");
        GM().consume(_NFTID, _consumingNFTID, _producableProductionType, _amount);
    }

    function giveStat(
        uint256 _NFTID,
        uint256 _amount,
        string memory _statName
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNNFT");
        GM().giveStat(_NFTID, _amount, _statName);
    }
    
    function breedTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        addressCheck(E().ownerOf(_NFT1ID), msg.sender, "OWNNFT1");
        uint256 newNFTID = GM().breedTwoCharacters(_NFT0ID, _NFT1ID);
        emit NewNFT(newNFTID);
        return newNFTID;
    }

    function mergeTwoCharacters(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256) {
        addressCheck(E().ownerOf(_NFT0ID), msg.sender, "OWNNFT0");
        addressCheck(E().ownerOf(_NFT1ID), msg.sender, "OWNNFT1");
        uint256 newNFTID = GM().mergeTwoCharacters(_NFT0ID, _NFT1ID);
        emit NewNFT(newNFTID);
        return newNFTID;
    }

    function newCharacter() external returns (uint256) {
        uint256 newNFTID = MM().newCharacter(
        msg.sender
        );
        emit NewNFT(newNFTID);
        return newNFTID;
    }

    function rename(
        uint256 _NFTID,
        string memory _newName
    ) external returns (string memory) {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE");
        string memory newNFTName = E0M().rename(_NFTID, _newName);
        emit NewNFTName(newNFTName);
        return newNFTName;
    }
    
    function destroyConsumable(
        uint256 _NFTID,
        uint256 _consumableNFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        addressCheck(E().ownerOf(_consumableNFTID), msg.sender, "OWNTYPE2");
        GM().destroyConsumable(_NFTID, _consumableNFTID);
    }

    function produce(
        uint256 _NFTID,
        uint256 _producableNFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        addressCheck(E().ownerOf(GG("PRODUCABLE", _producableNFTID, "PLACEDIN")), msg.sender, "OWNTYPE5");
        GM().produce(
            _NFTID,
            _producableNFTID
        );
    }
    
    function buyProducable(
        uint256 _produces,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        uint256 newNFTID = MM().newProducable(
            1,
            _produces,
            _NFTID
        );
        emit NewNFT(newNFTID);
        return newNFTID;
    }
    
    function buyEquippable(
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        uint256 newNFTID = MM().newEquippable(
            1,
            _itemSlot,
            _NFTID
        );
        emit NewNFT(newNFTID);
        return newNFTID;
    }

    function buyBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        uint256 newNFTID = MM().newBuilding(
            _area,
            _location,
            _NFTID
        );
        emit NewNFT(newNFTID);
        return newNFTID;
    }
    
    function equip(
        uint256 _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        addressCheck(E().ownerOf(_equipNFTID), msg.sender, "OWNTYPE3");
        GM().equip(
            _equipSlot,
            _equipNFTID,
            _NFTID
        );
    }

    function unequip(
        uint256 _equipSlot,
        uint256 _NFTID
    ) public {
        addressCheck(E().ownerOf(_NFTID), msg.sender, "OWNTYPE0");
        GM().unequip(
            _equipSlot,
            _NFTID
        );
    }

    function E() internal view returns (ERC42069I) {
        return ERC42069I(AA("ERC42069"));
    }

    function GM() internal view returns (GameMasterI) {
        return GameMasterI(AA("GAMEMASTER"));
    }

    function MM() internal view returns (MintMasterI) {
        return MintMasterI(AA("MINTMASTER"));
    }

    function E0M() internal view returns (Expansion0MasterI) {
        return Expansion0MasterI(AA("EXPANSION0MASTER"));
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
            d.setGD(_symbol, _NFTID, _statName, _statValue, "GREATFILTER");
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
        address _sender,
        string memory _checkName
    ) internal view {
        if (
            _target != _sender &&
            AA("WEB3BYPASS") != _sender) { // add a check to see if user has web3bypass enabled
            revert InvalidFilterSender({
                _target: _target,
                _sender: _sender,
                _checkName: _checkName
            });
        }
    }
}
