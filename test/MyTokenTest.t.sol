// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(myToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        //Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);
        myToken.approve(alice, initialAllowance);
        vm.prank(alice);
        myToken.transferFrom(bob, alice, initialAllowance / 2);

        assertEq(myToken.balanceOf(alice), initialAllowance / 2);
        assertEq(myToken.balanceOf(bob), STARTING_BALANCE - initialAllowance / 2);
    }

    // //check how much bob has given alice
    // function testBobAllowances () public view {
    // assertEq(myToken.allowance(bob, alice), 0);
    // }

    // Test transfer of tokens
    function testTransfer() public {
        uint256 amount = 1000;

        // Transfer tokens from deployer to user1
        vm.prank(msg.sender);
        address receiver = address(0x1);
        myToken.transfer(receiver, amount);
        assertEq(myToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialBalance = myToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        myToken.transfer(receiver, amount);
        assertEq(myToken.balanceOf(msg.sender), initialBalance - amount);
    }

    // Test transferring tokens using transferFrom
    function testTransferFrom() public {
        uint256 amount = 1000;

        // Approve user1 to spend on behalf of deployer
        address receiver = address(0x1);
        vm.prank(msg.sender);
        myToken.approve(address(this), amount);
        myToken.transferFrom(msg.sender, receiver, amount);
        assertEq(myToken.balanceOf(receiver), amount);
    }
}
