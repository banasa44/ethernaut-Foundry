// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

contract AttackMagicNum is Script {
    function run() external {
        // Start broadcasting the transaction
        vm.startBroadcast();

        // The raw bytecode for the minimal contract that returns 42 (0x2a)
        bytes
            memory bytecode = hex"600a600c600039600a6000f3602a60805260206080f3";

        // Deploy the bytecode using assembly
        address solver;
        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(solver != address(0), "Contract deployment failed!");

        console.log("Solver deployed at:", solver);

        // Check if the solver returns 42 when we call it
        (bool success, bytes memory returnData) = solver.call("");

        // Log the result
        if (success) {
            uint256 returnValue = abi.decode(returnData, (uint256));
            console.log("Solver returned:", returnValue);
            require(returnValue == uint(42), "Solver did not return 42!");
        } else {
            console.log("Solver call failed! Reverted.");
            revert("Solver call failed");
        }

        // Call the setSolver function on MagicNum contract
        address magicNumAddress = 0x09677E48eB9D3F8DC5c0361a47937B4804950fBb; // Replace with actual MagicNum contract address
        (bool successExercise, ) = magicNumAddress.call(
            abi.encodeWithSignature("setSolver(address)", solver)
        );
        require(successExercise, "Setting solver failed!");

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
