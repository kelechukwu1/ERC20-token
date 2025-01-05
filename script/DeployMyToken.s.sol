//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    function run() external {
        vm.startBroadcast();
        new MyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}