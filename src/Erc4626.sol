// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract Vault is ERC20 {
    ERC20 public asset;

    constructor(
        address _erc20,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
        asset = ERC20(_erc20);
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }
}
