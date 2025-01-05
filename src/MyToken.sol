//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract MyToken {
    mapping (address => uint) private s_balances;

    function name() public pure returns (string memory){
        return "My Token";
    }
}