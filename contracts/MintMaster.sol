//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface GreatFilterI {
    
    function equip(
        uint256 _equipSlot,
        uint256 _equipNFTID,
        uint256 _NFTID
    ) external;
}
interface ERC42069DataI {

    function r() external view returns (uint256);

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
    function mintCoins(uint256 _NFTID, uint256 _amount) external;

    function burnCoins(uint256 _NFTID, uint256 _amount) external;

    function gameTransferFrom(address _from, address _to, uint256 _amount) external;
}
interface ERC42069I {

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

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

    function addressCheckOr(
        address _target0,
        address _target1,
        address _sender
    ) external pure;

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
contract MintMaster is IERC721Receiver {
    
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
    ERC42069DataI d;
    uint256[] equipmentIDs = new uint256[](9);
    mapping(uint256 => bool) filledAreas;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function setArea(uint256 _area) external {
        if (filledAreas[_area] == false) {
            filledAreas[_area] = true;
            for (uint256 index = 0; index < 128; index++) {
                if (index % 3 == 1) {
                    internalGenerateCharacter(index % (_area + 1), 1, 2, _area, 0x000000000000000000000000000000000000dEaD);
                }
                if (index % 10 == 1) {
                    internalGenerateEquippedCharacter(index % (_area + 1), 1, _area, 0x000000000000000000000000000000000000dEaD);
                }
                internalGenerateBuilding(_area, index, 1);
            }
        }
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
        addressCheck(AA("EXPANSION0MASTER"), msg.sender);

        return internalGenerateCharacter(_level, _species, _special, _area, _mintTo);
    }

    function internalGenerateCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) internal returns (uint256) {
        uint256 charID = E().createNewCharacter(_level, _species, _special, _area, _mintTo);

        return charID;
    }

    function generateEquippedCharacter(
        uint256 _level,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) public returns (uint256) {
        addressCheck(AA("EXPANSION0MASTER"), msg.sender);

        return internalGenerateEquippedCharacter(_level, _special, _area, _mintTo);
    }

    function internalGenerateEquippedCharacter(
        uint256 _level,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) internal returns (uint256) {
        uint256 charID = E().createNewCharacter(_level, 0, _special, _area, address(this));
        equipmentIDs[0] = (E().createNewEquippable(_level, 0, charID));
        GF().equip(0, equipmentIDs[0], charID);

        equipmentIDs[1] = (E().createNewEquippable(_level, 1, charID));
        GF().equip(1, equipmentIDs[1], charID);

        equipmentIDs[2] = (E().createNewEquippable(_level, 2, charID));
        GF().equip(2, equipmentIDs[2], charID);

        equipmentIDs[3] = (E().createNewEquippable(_level, 3, charID));
        GF().equip(3, equipmentIDs[3], charID);

        if (d.r() % 3 > 1) {
            equipmentIDs[4] = (E().createNewEquippable(_level, 4, charID));
            GF().equip(4, equipmentIDs[4], charID);
        }

        if (d.r() % 230 >= 50) {
            equipmentIDs[5] = (E().createNewEquippable(_level, 5, charID));
            GF().equip(5, equipmentIDs[5], charID);
        }

        if (d.r() % 1000 >= 200) {
            equipmentIDs[6] = (E().createNewEquippable(_level, 6, charID));
            GF().equip(6, equipmentIDs[6], charID);
        }

        equipmentIDs[7] = (E().createNewEquippable(_level, 7, charID));
        GF().equip(7, equipmentIDs[7], charID);

        if (d.r() % 2 == 1) {
            equipmentIDs[8] = (E().createNewEquippable(_level, 8, charID));
            GF().equip(8, equipmentIDs[8], charID);
        }

        E().safeTransferFrom(address(this), _mintTo, charID);

        return charID;
    }

    function generateConsumable(
        uint256 _amount,
        uint256 _produces,
        uint256 _NFTID
    ) external {
        addressCheck(GFA(), msg.sender);
        internalGenerateConsumable(_amount, _produces, _NFTID);
    }

    function internalGenerateConsumable(
        uint256 _amount,
        uint256 _produces,
        uint256 _NFTID
    ) internal {
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
        addressCheck(GFA(), msg.sender);
        return E().createNewProducable(_level, _produces, _NFTID);
    }

    function generateEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GFA(), msg.sender);
        return internalGenerateEquippable(_level, _itemSlot, _NFTID);
    }

    function internalGenerateEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) internal returns (uint256) {
        RV().itemSlotCheck(_itemSlot);
        return E().createNewEquippable(_level, _itemSlot, _NFTID);
    }

    function internalGenerateBuilding(
        uint256 _area,
        uint256 _location,
        uint256 _NFTID
    ) internal returns (uint256) {
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
        addressCheck(AA("EXPANSION0MASTER"), msg.sender); // FIX??
        return E().createNewCharacter(_level, _species, _special, _area, _mintTo);
    }

    function newCharacter(
        address _mintTo
    ) external returns (uint256) {
        addressCheck(GFA(), msg.sender);
        uint256 NFTID = internalGenerateEquippedCharacter(1, 0, 0, _mintTo);
        ERC20CreditsI(AA("ERC20CREDITS")).mintCoins(NFTID, 1000 * 100);
        uint256 companionNFTID = internalGenerateCharacter(1, 1, 0, 0, _mintTo);
        SG("COMPANION", NFTID, "0", companionNFTID);
        internalGenerateConsumable(5, 0, NFTID);
        internalGenerateConsumable(5, 1, NFTID);
        internalGenerateEquippable(1, 0, NFTID);
        return NFTID;
        // takeCredits(_NFTID, "CHARACTERCOST"); // TAKE NETWORK CURRENCY INSTEAD
    }

    function newConsumable(
        uint256 _amount,
        uint256 _producableProductionType,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GFA(), msg.sender);
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
        addressCheck(GFA(), msg.sender);
        stateCheck(_NFTID, 0);
        takeCredits(_NFTID, "PRODUCABLECOST");
        return E().createNewProducable(_level, _produces, _NFTID);
    }
    
    function newEquippable(
        uint256 _level,
        uint256 _itemSlot,
        uint256 _NFTID
    ) external returns (uint256) {
        addressCheck(GFA(), msg.sender);
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
        addressCheck(GFA(), msg.sender);
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
        addressCheck(GFA(), msg.sender);
        return E().destroyConsumable(_NFTID, _consumableNFTID);
    }

    function E() internal view returns (ERC42069I) {
        return ERC42069I(AA("ERC42069"));
    }

    function addressCheckOr(
        address _target0,
        address _target1,
        address _sender
    ) internal view {
        RV().addressCheckOr(_target0, _target1, _sender);
    }

    function GF() internal view returns (GreatFilterI) {
        return GreatFilterI(GFA());
    }

    function GFA() internal view returns (address) {
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