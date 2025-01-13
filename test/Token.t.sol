// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/Token.sol";

contract TokenTest is Test {
    Token public token;
    address public owner;
    address public nonOwner;

    function setUp() public {
        owner = address(this); // the test contract is the owner
        nonOwner = address(0x1);

        token = new Token("Test Token", "TEST");
    }

    function testDeployment() public view {
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TEST");
        assertEq(token.owner(), address(this)); // teh test contract should be the owner
    }

    function testMintByOwner() public {
        token.mint(owner, 100);
        assertEq(token.totalSupply(), 100);
        assertEq(token.balanceOf(owner), 100);
    }

    function testMintByNonOwnerReverts() public {
        vm.prank(nonOwner); // pretending to be nonOwner
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(nonOwner, 100);
    }
}
