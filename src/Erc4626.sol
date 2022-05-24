// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract Vault is ERC20 {
    ERC20 public asset;

    event Deposit(string, address, uint256);

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

    //shares to be minted = assets to be added * (total shares / total asset)
    function convertToShares(uint256 _assets) public view returns (uint256) {
        if (totalSupply == 0) {
            return _assets;
        } else {
            return (_assets * totalSupply) / totalAssets();
        }
    }

    //assets to be exchanged = shares to be burn * (total asset / total shares)
    function convertToAssets(uint256 _shares) public view returns (uint256) {
        if (totalSupply == 0) {
            return _shares;
        } else {
            return (_shares * totalAssets()) / totalSupply;
        }
    }

    function deposit(uint256 _assets, address receiver)
        public
        returns (uint256 shares)
    {
        //approve this contract for transferFrom
        asset.transferFrom(msg.sender, address(this), _assets);
        shares = convertToShares(_assets);
        _mint(receiver, shares);
        emit Deposit("Deposited ", msg.sender, _assets);
    }
}
