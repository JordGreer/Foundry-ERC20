//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    OurToken public ourToken;
    DeployOurToken public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 10 ether);
        assertEq(ourToken.balanceOf(alice), 10 ether);
    }

    /* function testAllowances() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        assertEq(ourToken.allowance(bob, alice), initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(
            ourToken.allowance(bob, alice),
            initialAllowance - transferAmount
        );
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }
 */
    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    function testAllowance() public {
        uint256 amount = 100;
        uint256 transferAmount = 50;

        vm.startBroadcast(bob);
        ourToken.approve(alice, amount);
        assertEq(ourToken.allowance(bob, alice), amount, "Incorrect allowance");
        vm.stopBroadcast();

        vm.startBroadcast(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        vm.stopBroadcast();

        assertEq(
            ourToken.balanceOf(alice),
            transferAmount,
            "Incorrect balance after transferFrom"
        );

        assertEq(
            ourToken.allowance(bob, alice),
            amount - transferAmount,
            "Allowance should be reset after transferFrom"
        );
    }

    // Not working, please fix :o
    /* function testTransfers() public {
        address account1 = address(0x123);
        address account2 = address(0x456);
        uint256 amount = 100;

        ourToken.transfer(account1, amount);
        assertEq(
            ourToken.balanceOf(account1),
            amount,
            "Incorrect balance after transfer"
        );

        ourToken.transferFrom(account1, account2, amount);
        assertEq(
            ourToken.balanceOf(account1),
            0,
            "Incorrect balance after transferFrom"
        );
        assertEq(
            ourToken.balanceOf(account2),
            amount,
            "Incorrect balance after transferFrom"
        );
    } */
}
