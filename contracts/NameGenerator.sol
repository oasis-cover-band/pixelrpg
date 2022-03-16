//SPDXLicenseIdentifier: Unlicense
pragma solidity ^0.8.0;

error InvalidSender(address _target, address _sender);

interface ERC42069DataI {

    function r() external view returns (uint256);
    function getAA(string memory _name) external view returns (address);
}

contract NameGenerator {
     string[] public names;

    ERC42069DataI d;
    constructor(
        address _dataAddress
    )
        {
        d = ERC42069DataI(_dataAddress);
    }
    function getRandomName() public view returns (string memory) {
         return names[d.r() % names.length];
    }
    function addName(string[] memory _names) public {
        if (d.getAA("SETUP") != msg.sender) {
            revert InvalidSender({
                _target: d.getAA("SETUP"),
                _sender: msg.sender
            });
        }
        for (uint256 index = 0; index < _names.length; index++) {
            names.push(_names[index]);
        }
    }
}