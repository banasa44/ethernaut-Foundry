// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Denial.sol";
import "../script/AttackDenial.s.sol";

contract DenialTest is Test {
    Denial denial;
    AttackDenial attackDenial;
    address owner;

    function setUp() public {
        // Set up the Denial contract
        denial = new Denial();

        // Deploy the attack contract
        attackDenial = new AttackDenial();

        // Fund the Denial contract with 10 ether
        payable(address(denial)).transfer(10 ether);

        // Check if the contract is funded
        assertEq(denial.contractBalance(), 10 ether);
    }

    function testDenialAttack() public {
        // Set the attack contract as the partner
        denial.setWithdrawPartner(address(attackDenial));

        // Start with a higher gas limit and progressively reduce it to simulate gas exhaustion.
        uint256 gasAmount = 1_000_000;

        bool success;

        // Try to withdraw and expect the transaction to fail due to gas consumption.
        while (gasAmount > 10_000) {
            // Perform the call with the current gas limit
            (success, ) = address(denial).call{gas: gasAmount}(
                abi.encodeWithSignature("withdraw()")
            );

            if (success) {
                emit log_named_uint("Gas limit that worked", gasAmount);
                break;
            } else {
                emit log_named_uint("Gas limit failed", gasAmount);
            }

            // Reduce gas by 10,000 in each iteration
            gasAmount -= 10_000;
        }

        // After trying with various gas limits, the attack should have failed for low gas amounts
        assertTrue(
            !success,
            "The withdraw function should fail due to gas exhaustion"
        );

        // Ensure contract balance remains unchanged
        assertEq(denial.contractBalance(), 10 ether);
    }
}
