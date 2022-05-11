// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/WEth.sol";

contract WEthTest is Test {
    WEth weth;
    Vm private constant _Vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        weth = new WEth("Wrapped Eth", "WEth", 18);
    }

    function testWEthDeposit() public {
        address user1 = address(0xabcd);
        _Vm.deal(user1, 100 ether);
        require(user1.balance == 100 ether);
        console.log(
            "weth eth before balance is ",
            address(weth).balance / 10**18
        );
        _Vm.prank(user1);
        weth.deposit{value: 1 ether}();
        console.log(
            "weth eth after balance is ",
            address(weth).balance / 10**18
        );
        console.log(
            "user1 eth balance is ",
            user1.balance / 10**weth.decimals()
        );
        console.log(
            "user1 weth balance is ",
            weth.balanceOf(user1) / 10**weth.decimals()
        );
    }
}
