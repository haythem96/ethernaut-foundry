pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/King/KingFactory.sol";
import "../src/Ethernaut.sol";
import "./KingTestBreak.sol";

contract KingTest is Test {
    address alice = address(0x1337);
    address random = address(0xabcd);

    Ethernaut ethernaut;
    King ethernautKing;
    KingTestBreak king4ever;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "KingTest");

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();

        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        ethernautKing = King(payable(levelAddress));

        vm.label(address(ethernautKing), "EthernautKing");
        king4ever = new KingTestBreak();
        vm.label(address(king4ever), "King4Ever");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public payable {
        vm.startPrank(alice);
        king4ever.exploit{value: ethernautKing.prize() + 1e18}(address(ethernautKing));
        vm.stopPrank();

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautKing)));

        assert(levelSuccessfullyPassed);
    }

}