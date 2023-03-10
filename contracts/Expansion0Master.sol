//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC42069RevertsI {
    
    function teachCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _skill
    ) external view;

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) external pure;

    function questCheck(
        uint256 _NFTID,
        uint256 _questID
    ) external view;

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) external view;

    function addressCheck(
        address _target,
        address _sender
    ) external pure;

    function attackChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;

    function startBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;

    function endBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;

    function fleeBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;

    function captureEnemyChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external view;
}
interface ERC42069DataI {

    function n2s(uint _i) external pure returns (string memory);
    function getGS(string memory _setting) external view returns (uint256);

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

    function getAA(string memory _name) external view returns (address);

    function r() external view returns (uint256);
}
interface ERC42069I {

    function gameTransferFrom(
        uint256 _NFTID,
        address _to
    ) external;

    function ownerOf(
        uint256 _NFTID
    ) external returns (address);
}
interface MintMasterI {

    function replaceCapturedOrKilledCharacter(
        uint256 _level,
        uint256 _species,
        uint256 _special,
        uint256 _area,
        address _mintTo
    ) external returns (uint256);
}
contract Expansion0Master {
    
    ERC42069DataI d;
    uint256 battleCount;
    uint256 attackCount;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
        battleCount = 1;
        attackCount = 1;
    }

    function rename(
        uint256 _NFTID,
        string memory _newName
    ) external returns (string memory) {
        addressCheck(AA("GREATFILTER"), msg.sender);
        SGN("GENERAL", _NFTID, "NAME", _newName);
        return _newName;
    }
    function attackEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external returns (uint256, uint256, uint256, uint256) {
        addressCheck(AA("GREATFILTER"), msg.sender);
        attackChecks(_NFT0ID, _NFT1ID);
        (uint256 damageDone, uint256 special0Index) = basicAttack(_NFT0ID, _NFT1ID);
        (uint256 damageReceived, uint256 special1Index) = enemyAttack(_NFT0ID, _NFT1ID);
        console.log("Attack0:'%s', HP0:'%s'", 
        damageDone, GG("CHARACTER", _NFT0ID, "HEALTH"));
        console.log("Attack1:'%s', HP1:'%s'", 
        damageReceived,   GG("CHARACTER", _NFT1ID, "HEALTH"));
        return (damageDone, damageReceived, special0Index, special1Index);
    }
    function attackEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _specialAttack
    ) external returns (uint256, uint256, uint256, uint256) {
        addressCheck(AA("GREATFILTER"), msg.sender);
        attackChecks(_NFT0ID, _NFT1ID);
        (uint256 damageDone, uint256 special0Index) = specialAttack(_NFT0ID, _NFT1ID, _specialAttack);
        (uint256 damageReceived, uint256 special1Index) = enemyAttack(_NFT0ID, _NFT1ID);
        console.log("sAttack0:'%s', HP0:'%s'", 
        damageDone, GG("CHARACTER", _NFT0ID, "HEALTH"));
        console.log("Attack1:'%s', HP1:'%s'", 
        damageReceived,   GG("CHARACTER", _NFT1ID, "HEALTH"));
        return (damageDone, damageReceived, special0Index, special1Index);
    }
    function enemyAttack(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal returns (uint256, uint256) {
        uint256 _specialAttack = d.r() % GS("MAXSPECIALS");
        if(GG("CHARACTER", _NFT1ID, d.n2s(_specialAttack)) > 1 &&
        (GG("CHARACTER", _NFT1ID, "ENERGY") >= (GG("SPECIALS", _specialAttack, "ENERGYCOST")) * GG("CHARACTER", _NFT1ID, d.n2s(_specialAttack))) &&
        d.r() % 3 > 1) {
            return specialAttack(_NFT1ID, _NFT0ID, _specialAttack);
        } else {
            return basicAttack(_NFT1ID, _NFT0ID);
        }
    }

    function basicAttack(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal returns (uint256, uint256) {
        uint256 dmg = 1 + (attackCount * 2312839012309 + d.r()) % GG("CHARACTER", _NFT0ID, "STRENGTH");
        uint256 ehp = GG("CHARACTER", _NFT1ID, "HEALTH");
        if (dmg >= ehp) {
            SG("CHARACTER", _NFT1ID, "HEALTH", 0);
            dmg = ehp;
        } else {
            SG("CHARACTER", _NFT1ID, "HEALTH", ehp - dmg);
        }
        attackCount++;
        return (dmg, 0);
    }
    function specialAttack(uint256 _NFT0ID, uint256 _NFT1ID, uint256 _specialAttack) internal returns (uint256, uint256) {
        if(GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack)) > 0 &&
        (GG("CHARACTER", _NFT0ID, "ENERGY") >= (GG("SPECIALS", _specialAttack, "ENERGYCOST") * GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack))))) {
            uint256 mod = (
                (GG("CHARACTER", _NFT0ID, "STRENGTH") * GG("SPECIALS", _specialAttack, "STRENGTHDAMAGE"))
                + (GG("CHARACTER", _NFT0ID, "DEXTERITY") * GG("SPECIALS", _specialAttack, "DEXTERITYDAMAGE"))
                + (GG("CHARACTER", _NFT0ID, "CHARISMA") * GG("SPECIALS", _specialAttack, "CHARISMADAMAGE"))
                + (GG("CHARACTER", _NFT0ID, "INTELLIGENCE") * GG("SPECIALS", _specialAttack, "INTELLIGENCEDAMAGE"))
            ) * GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack));
            uint256 dmg = 1 + ((attackCount * 4324839092 + d.r()) % ((mod + 100) / 100));
            uint256 ehp = GG("CHARACTER", _NFT1ID, "HEALTH");
            uint256 nrgcost = GG("SPECIALS", _specialAttack, "ENERGYCOST") * GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack));
            uint256 nrg = GG("CHARACTER", _NFT0ID, "ENERGY");
            if (nrgcost >= nrg) {
                SG("CHARACTER", _NFT0ID, "ENERGY", 0);
            } else {
                SG("CHARACTER", _NFT0ID, "ENERGY", nrg - nrgcost);
            }
            if (dmg >= ehp) {
                SG("CHARACTER", _NFT1ID, "HEALTH", 0);
            } else {
                SG("CHARACTER", _NFT1ID, "HEALTH", ehp - dmg);
            }
            attackCount++;
            return (dmg, _specialAttack);
        } else {
            console.log("Failed Special Attack. CENERGY: '%s', RENERGY: '%s'', SLEVEL: '%s'", GG("CHARACTER", _NFT0ID, "ENERGY"), GG("SPECIALS", _specialAttack, "ENERGYCOST") * GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack)), GG("CHARACTER", _NFT0ID, d.n2s(_specialAttack))); 
            return basicAttack(_NFT0ID, _NFT1ID);
        }
    }

    // function startSparring(
    //     uint256 _NFT0ID,
    //     uint256 _NFT1ID
    // ) external {
    //     addressCheck(AA("GREATFILTER"), msg.sender);
    //     startBattleChecks(_NFT0ID, _NFT1ID);
    //     SG("CHARACTER", _NFT0ID, "STATE", 69);
    //     SG("CHARACTER", _NFT1ID, "STATE", 69);
    // }

    function startBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        uint256 bc = battleCount;
        addressCheck(AA("GREATFILTER"), msg.sender);
        startBattleChecks(_NFT0ID, _NFT1ID);
        SG("CHARACTER", _NFT0ID, "STATE", 420);
        SG("CHARACTER", _NFT1ID, "STATE", 420);
        SG("CHARACTER", _NFT0ID, "VS", _NFT1ID);
        SG("CHARACTER", _NFT1ID, "VS", _NFT0ID);
        SG("CHARACTER", _NFT0ID, "BATTLEID", bc);
        SG("CHARACTER", _NFT1ID, "BATTLEID", bc);
        SG("STATS", _NFT0ID, "FIGHTS", GG("STATS", _NFT0ID, "FIGHTS") + 1);
        battleCount++;
    }

    function endBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        endBattleChecks(_NFT0ID, _NFT1ID);
        fleeBattle(_NFT0ID, _NFT1ID);
    }

    function fleeBattle(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) public {
        addressCheck(AA("GREATFILTER"), msg.sender);
        fleeBattleChecks(_NFT0ID, _NFT1ID);
        SG("CHARACTER", _NFT0ID, "STATE", 0);
        SG("CHARACTER", _NFT1ID, "STATE", 0);
        SG("CHARACTER", _NFT0ID, "BATTLEID", 0);
        SG("CHARACTER", _NFT1ID, "BATTLEID", 0);
        SG("CHARACTER", _NFT0ID, "VS", 0);
        SG("CHARACTER", _NFT1ID, "VS", 0);
        SG("CHARACTER", _NFT1ID, "HEALTH", GG("CHARACTER", _NFT1ID, "MAXHEALTH"));
        SG("CHARACTER", _NFT1ID, "ENERGY", GG("CHARACTER", _NFT1ID, "MAXENERGY"));
    }

    function captureEnemy(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        captureEnemyChecks(_NFT0ID, _NFT1ID);
        SG("GENERAL", _NFT1ID, "SPECIAL", 0);
        SG("STATS", _NFT0ID, "CAPTURED", GG("STATS", _NFT0ID, "CAPTURED") + 1);
        fleeBattle(_NFT0ID, _NFT1ID);
        ERC42069I(AA("ERC42069")).gameTransferFrom(
            _NFT1ID,
            ERC42069I(AA("ERC42069")).ownerOf(_NFT0ID)
        );
        MintMasterI(AA("MINTMASTER")).replaceCapturedOrKilledCharacter(
            d.r() % GS("MAXTOTALLEVEL") + 1,
            d.r() % GS("MAXSPECIES") + 1,
            GG("GENERAL", _NFT1ID, "SPECIAL"),
            GG("GENERAL", _NFT1ID, "AREA"),
            0x000000000000000000000000000000000000dEaD
        );
    }

    function teachSpecial(
        uint256 _NFTID,
        uint256 _skill
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        SG("CHARACTER", _NFTID, d.n2s(_skill + 42069), GG("CHARACTER", _NFTID, d.n2s(_skill + 42069)) + 1);
    }

    function startQuest(
        uint256 _NFTID,
        uint256 _questID
    ) public {
        addressCheck(AA("GREATFILTER"), msg.sender);
        stateCheck(_NFTID, 0);
        SG("CHARACTER", _NFTID, "STATE", 42069);
        SG("CHARACTER", _NFTID, "QUESTID", _questID);
        SG("CHARACTER", _NFTID, "QUESTTIMER", GS("QUESTTIMER") * _questID);
        SG("STATS", _NFTID, "QUESTS", GG("STATS", _NFTID, "QUESTS") + 1);
    }

    function finishQuest(
        uint256 _NFTID,
        uint256 _questID
    ) public {
        addressCheck(AA("GREATFILTER"), msg.sender);
        stateCheck(_NFTID, 42069);
        questCheck(_NFTID, _questID);
        timerCheck(GG("CHARACTER", _NFTID, "QUESTTIMER"), block.timestamp, "QUESTTIMER");
        SG("CHARACTER", _NFTID, "STATE", 0);
        SG("CHARACTER", _NFTID, "QUESTID", 0);
    }

    function AA(
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
    }

    function GG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName
    ) internal view returns (uint256) {
        return d.getGD(_symbol, _NFTID, _statName);
    }

    function GS (
        string memory _setting
    ) internal view returns (uint256) {
            return d.getGS(_setting);
    }

    function SG(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        uint256 _statValue
    ) internal {
            d.setGD(_symbol, _NFTID, _statName, _statValue, "EXPANSION0MASTER");
    }

    function SGN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue
    ) internal {
            d.setGDN(_symbol, _NFTID, _statName, _statValue, "EXPANSION0MASTER");
    }

    function teachCheck(
        uint256 _NFT0ID,
        uint256 _NFT1ID,
        uint256 _skill
    ) internal view {
        RV().teachCheck(
            _NFT0ID,
            _NFT1ID,
            _skill
        );
    }

    function stateCheck(
        uint256 _NFTID,
        uint256 _requiredState
    ) internal view {
        RV().stateCheck(_NFTID, _requiredState);
    }

    function timerCheck(
        uint256 _value,
        uint256 _mustBeBefore,
        string memory _timerName
    ) internal view {
        RV().timerCheck(_value, _mustBeBefore, _timerName);
    }

    function questCheck(
        uint256 _NFTID,
        uint256 _questID
    ) internal view {
        RV().questCheck(_NFTID, _questID);
    }

    function attackChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().attackChecks(_NFT0ID, _NFT1ID);
    }

    function startBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().startBattleChecks(_NFT0ID, _NFT1ID);
    }

    function endBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().endBattleChecks(_NFT0ID, _NFT1ID);
    }

    function fleeBattleChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().fleeBattleChecks(_NFT0ID, _NFT1ID);
    }

    function captureEnemyChecks(
        uint256 _NFT0ID,
        uint256 _NFT1ID
    ) internal view {
        RV().captureEnemyChecks(_NFT0ID, _NFT1ID);
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        RV().addressCheck(_target, _sender);
    }
    
    function RV() internal view returns (ERC42069RevertsI) {
        return ERC42069RevertsI(AA("ERC42069REVERTS"));
    }
    
}
