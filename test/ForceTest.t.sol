pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Force/ForceFactory.sol";
import "../src/Ethernaut.sol";
import "./ForceTestDestruct.sol";

contract ForceTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Force ethernautForce;

    fallback() external {
        payable(address(ethernautForce)).send(1 ether);
    }

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "ForceTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        ethernautForce = Force(payable(levelAddress));

        vm.label(address(ethernautForce), "EthernautForce");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        ForceTestDestruct forceTestDestruct = new ForceTestDestruct();
        forceTestDestruct.attack{value: 1 ether}(address(ethernautForce));
        
        emit log_named_uint("Force contract balance", address(ethernautForce).balance);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautForce)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}