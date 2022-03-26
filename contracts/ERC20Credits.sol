//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ERC42069DataI {

    function getAA(string memory _name) external view returns (address);
}
interface ERC42069I {

    function ownerOf(uint256 _tokenID) external returns (address owner_);
}
interface ERC42069RevertsI {

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
 contract ERC20Credits is ERC20 {

    ERC42069DataI d;
    constructor(
        string memory _typeName,
        string memory _typeSymbol,
        address _dataAddress
    ) ERC20(_typeName, _typeSymbol) {
        d = ERC42069DataI(_dataAddress);
        console.log("Created ERC20Credits: NAME:'%s' SYMBOL:'%s' D:'%s'", _typeName, _typeSymbol, _dataAddress);
    }

    function mintCoins(uint256 _NFTID, uint256 _amount) external {
        addressCheckOr(AA("GREATFILTER"), AA("MINTMASTER"), msg.sender);
        _mint(ERC42069I(AA("ERC42069")).ownerOf(_NFTID), _amount);
        console.log("Minted ERC20Credits TO:'%s' AMOUNT:'%s' D:'%s'", ERC42069I(AA("ERC42069")).ownerOf(_NFTID), _amount);
    }

    function burnCoins(uint256 _NFTID, uint256 _amount) external {
        addressCheckOr(AA("GAMEMASTER"), AA("MINTMASTER"), msg.sender);
        _burn(ERC42069I(AA("ERC42069")).ownerOf(_NFTID), _amount);
        console.log("Burned ERC20Credits FROM:'%s' AMOUNT:'%s' D:'%s'", ERC42069I(AA("ERC42069")).ownerOf(_NFTID), _amount);
    }

    function gameTransferFrom(address _from, address _to, uint256 _amount) external {
        addressCheckOr(AA("GAMEMASTER"), AA("MINTMASTER"), msg.sender);
        _transfer(
        _from,
        _to,
        _amount);
        console.log("Transferred ERC20Credits FROM:'%s' 'TO:'%s' AMOUNT:'%s'", _from, _to, _amount);
    }
    function AA(
        string memory _name
    ) internal view returns (address) {
        return d.getAA(_name);
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
}