//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC42069RevertsI {

    function addressCheck(
        address _target,
        address _sender
    ) external pure;
}
interface ERC42069DataI {

    function setGDN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue,
        string memory _msgSender
    ) external;

    function getAA(string memory _name) external view returns (address);
}
contract Expansion0Master {
    
    ERC42069DataI d;
    constructor(
        address _dataAddress
    ) {
        d = ERC42069DataI(_dataAddress);
    }

    function rename(
        uint256 _NFTID,
        string memory _newName
    ) external {
        addressCheck(AA("GREATFILTER"), msg.sender);
        SGN("GENERAL", _NFTID, "NAME", _newName);
    }

    function AA(
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
    }

    function SGN(
        string memory _symbol,
        uint256 _NFTID,
        string memory _statName,
        string memory _statValue
    ) internal {
            d.setGDN(_symbol, _NFTID, _statName, _statValue, "EXPANSION0MASTER");
    }

    function addressCheck(
        address _target,
        address _sender
    ) internal view {
        ERC42069RevertsI(AA("ERC42069REVERTS")).addressCheck(_target, _sender);
    }
    
}
