// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "solmate/tokens/ERC20.sol";

contract WEth is ERC20 {
    event depositLog(string, address, uint256);
    event withdrawLog(string, address, uint256);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {}

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit depositLog("Deposit by ", msg.sender, msg.value);
    }

    function withdraw(uint256 _val)
        external
        returns (bool result, bytes memory log)
    {
        _burn(msg.sender, _val);
        (result, log) = payable(msg.sender).call{value: _val}("");
        emit withdrawLog("Withdraw by ", msg.sender, _val);
    }

    fallback() external payable {
        deposit();
    }
}
