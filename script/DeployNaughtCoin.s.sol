// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol"; // Import Foundry's Script library for deployment
import "../src/NaughtCoin.sol"; // Path to your contract

contract DeployNaughtCoin is Script {
    function run() external {
        vm.startBroadcast(); // Starts broadcasting the transactions

        // Replace with the address of the player
        address player = vm.envAddress("PLAYER_ADDRESS");

        // Deploy the NaughtCoin contract
        NaughtCoin naughtCoin = new NaughtCoin(player);

        console.log("NaughtCoin deployed to:", address(naughtCoin));

        vm.stopBroadcast(); // Stops broadcasting
    }
}
