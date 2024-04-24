// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { AttackNaiveReceiver } from "../src/AttackNaiveReceiver.sol";
import { FlashLoanReceiver } from "../src/FlashLoanReceiver.sol";
import { NaiveReceiverLenderPool } from "../src/NaiveReceiverLenderPool.sol";

contract NaiveReceiver is Test {

    uint256 public constant ETHER_IN_POOL = 100e18;
    uint256 public constant ETHER_IN_RECEIVER = 10e18;

    AttackNaiveReceiver attackNaiveReceiver;
    FlashLoanReceiver flashLoanReceiver;
    NaiveReceiverLenderPool naiveReceiverLenderPool;

    function setUp() external {
        naiveReceiverLenderPool = new NaiveReceiverLenderPool();
        flashLoanReceiver = new FlashLoanReceiver(address(naiveReceiverLenderPool));
        vm.deal(address(naiveReceiverLenderPool), ETHER_IN_POOL);
        vm.deal(address(flashLoanReceiver), ETHER_IN_RECEIVER);
    }

    function test_hack() public {
        attackNaiveReceiver = new AttackNaiveReceiver(address(naiveReceiverLenderPool), address(flashLoanReceiver));

        assertEq(address(flashLoanReceiver).balance, 0);
    }

}


