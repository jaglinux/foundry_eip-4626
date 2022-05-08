// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Erc4626.sol";
import "solmate/tokens/ERC20.sol";
import "forge-std/console.sol";

contract MockERC20 is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {}
}

contract Erc4626Test is Test {
    Vault public vault;
    ERC20 public underlying;

    function setUp() public {
        underlying = new MockERC20("TEST", "TST", 18);
        vault = new Vault(address(underlying), "TESTVAULT", "vTST", 18);
    }

    function testTotalSupplyShares() public view {
        console.log(vault.totalSupply());
        require(vault.totalSupply() == 0);
    }
}
