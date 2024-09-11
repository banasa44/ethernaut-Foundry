// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/NaughtCoin/NaughtCoin.sol";

contract DeployNaughtCoin is Script {
    function run() external {
        vm.startBroadcast();

        // Fetch player address depending on the environment
        address player;

        if (block.chainid == 1) {
            // Mainnet example (use environment variable for Mainnet)
            player = vm.envAddress("MAINNET_PLAYER_ADDRESS");
        } else if (block.chainid == 11155111) {
            // Sepolia (use different env variable for Sepolia)
            player = vm.envAddress("SEPOLIA_PLAYER_ADDRESS");
        } else {
            // Default for local testing
            player = address(0xdeadbeef); // Replace with the local address you want to use
        }

        // Deploy the NaughtCoin contract
        NaughtCoin naughtCoin = new NaughtCoin(player);

        console.log("NaughtCoin deployed to:", address(naughtCoin));

        vm.stopBroadcast();
    }
}
