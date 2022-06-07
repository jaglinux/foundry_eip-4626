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
    ) ERC20(_name, _symbol, _decimals) {
        _mint(msg.sender, 1000 * (10**_decimals));
    }
}

contract Erc4626Test is Test {
    Vault public vault;
    ERC20 public underlying;

    function setUp() public {
        underlying = new MockERC20("TEST", "TST", 18);
        vault = new Vault(address(underlying), "TESTVAULT", "vTST", 18);
    }

    function testTotalSupplyShares() public {
        require(vault.totalSupply() == 0);
        underlying.approve(address(vault), 10 * (10**18));
        vault.deposit(10 * (10**18), address(this));

        require(underlying.balanceOf(address(this)) / 10**18 == 990);
        require(underlying.balanceOf(address(vault)) / 10**18 == 10);
        require(vault.balanceOf(address(this)) / 10**18 == 10);
        require(vault.totalSupply() == 10 * (10**18));
    }

    function testDepositandRedeem() public {
        underlying.approve(address(vault), 10 * (10**18));
        uint256 _shares = vault.deposit(10 * (10**18), address(this));
        console.log("share is ", _shares / (10**18));
        uint256 _assets = vault.redeem(_shares, address(this), address(this));
        console.log("asset is ", _assets);
    }
}
