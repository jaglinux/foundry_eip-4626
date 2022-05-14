// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/WEth.sol";

interface IWEth {
    function deposit() external payable;

    function withdraw(uint256) external;
}

contract MockHacker {
    address wethAddress;

    constructor(address _addr) {
        wethAddress = _addr;
    }

    function deposit() external {
        IWEth(wethAddress).deposit{value: 1 ether}();
    }

    function withdraw(uint256 _val) external {
        IWEth(wethAddress).withdraw(_val);
    }

    receive() external payable {}
}

contract WEthTest is Test {
    WEth weth;
    Vm private constant _Vm = Vm(HEVM_ADDRESS);
    address private constant user1 = address(0xabcd);

    function setUp() public {
        weth = new WEth("Wrapped Eth", "WEth", 18);
        _Vm.deal(user1, 100 ether);
    }

    function testWEthDeposit() public {
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
        require(weth.balanceOf(user1) == 1 ether);
    }

    function testWEthDepositFallback() public {
        require(user1.balance == 100 ether);
        _Vm.prank(user1);
        (bool result, bytes memory data) = address(weth).call{value: 1 ether}(
            ""
        );
        console.log(result);
        console.logBytes(data);
        console.log("weth eth balance is ", address(weth).balance / 10**18);
        console.log("user1 eth balance is ", user1.balance / 10**18);
        console.log(
            "user1 weth balance is ",
            weth.balanceOf(user1) / 10**weth.decimals()
        );
        require(weth.balanceOf(user1) == 1 ether);
    }

    function testWithdraw() public {
        require(user1.balance == 100 ether);
        _Vm.prank(user1);
        weth.deposit{value: 2 ether}();
        console.log("user1 eth balance is ", user1.balance / 10**18);
        _Vm.prank(user1);
        weth.withdraw(1 ether);
        console.log("user1 eth balance is ", user1.balance / 10**18);
        require(user1.balance == 99 ether);
        _Vm.prank(user1);
        weth.withdraw(1 ether);
        console.log("user1 eth balance is ", user1.balance / 10**18);
        require(user1.balance == 100 ether);
    }

    function testWithdrawHack() public {
        MockHacker _mock = new MockHacker(address(weth));
        _Vm.deal(address(_mock), 100 ether);
        console.log(
            "mock contract before eth is ",
            address(_mock).balance / 10**18
        );
        console.log("weth before balance is ", address(weth).balance / 10**18);
        _mock.deposit();
        console.log(
            "mock contract after eth is ",
            address(_mock).balance / 10**18
        );
        console.log("weth after balance is ", address(weth).balance / 10**18);
        require(address(weth).balance == 1 ether);
        _mock.withdraw(1 ether);
        console.log(
            "mock contract after eth is ",
            address(_mock).balance / 10**18
        );
    }
}
