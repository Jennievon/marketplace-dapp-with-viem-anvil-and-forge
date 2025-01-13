// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/Token.sol";
import "../contracts/Marketplace.sol";

contract MarketplaceTest is Test {
    Token public token;
    Marketplace public marketplace;
    address public seller;
    address public buyer;

    function setUp() public {
        token = new Token("Test Token", "TEST");
        marketplace = new Marketplace(address(token));
        seller = address(0x1);
        buyer = address(0x2);

        // setup initial balances
        token.mint(buyer, 1000 ether);
    }

    function testListItem() public {
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            100 ether
        );
        assertEq(itemId, 1);

        Marketplace.Item memory item = marketplace.getItem(itemId);
        assertEq(item.id, 1);
        assertEq(item.seller, seller);
        assertEq(item.name, "Test Item");
        assertEq(item.price, 100 ether);
        assertTrue(item.active);

        Marketplace.Item[] memory activeItems = marketplace.getActiveItems();
        assertEq(activeItems.length, 1);
        assertEq(activeItems[0].id, itemId);
    }

    function testBuyItem() public {
        // List item
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            100 ether
        );

        // approve and buy
        vm.prank(buyer);
        token.approve(address(marketplace), 100 ether);

        vm.prank(buyer);
        marketplace.buyItem(itemId);

        assertEq(token.balanceOf(seller), 100 ether);
        assertEq(token.balanceOf(buyer), 900 ether);

        Marketplace.Item memory item = marketplace.getItem(itemId);
        assertFalse(item.active);

        Marketplace.Item[] memory activeItems = marketplace.getActiveItems();
        assertEq(activeItems.length, 0); // no active items after purchase
    }

    function testGetActiveItems() public {
        // List multiple items
        vm.prank(seller);
        marketplace.listItem("Item 1", "Description 1", 100 ether);

        vm.prank(seller);
        uint256 itemId2 = marketplace.listItem(
            "Item 2",
            "Description 2",
            200 ether
        );

        // buy one item
        vm.prank(buyer);
        token.approve(address(marketplace), 200 ether);

        vm.prank(buyer);
        marketplace.buyItem(itemId2);

        // verify only one item remains active
        Marketplace.Item[] memory activeItems = marketplace.getActiveItems();
        assertEq(activeItems.length, 1);
        assertEq(activeItems[0].name, "Item 1");
        assertEq(activeItems[0].price, 100 ether);
    }

    function testDelistItem() public {
        // List an item
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            100 ether
        );

        // Delist the item
        vm.prank(seller);
        marketplace.delistItem(itemId);

        Marketplace.Item memory item = marketplace.getItem(itemId);
        assertFalse(item.active);

        Marketplace.Item[] memory activeItems = marketplace.getActiveItems();
        assertEq(activeItems.length, 0); // No active items after delisting
    }

    function testCannotBuyOwnItem() public {
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            100 ether
        );

        vm.prank(seller);
        vm.expectRevert("Cannot buy your own item");
        marketplace.buyItem(itemId);
    }

    function testInsufficientAllowance() public {
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            100 ether
        );

        vm.prank(buyer);
        vm.expectRevert("Insufficient allowance");
        marketplace.buyItem(itemId);
    }

    function testInsufficientBalance() public {
        vm.prank(seller);
        uint256 itemId = marketplace.listItem(
            "Test Item",
            "Description",
            2000 ether
        );

        vm.prank(buyer);
        token.approve(address(marketplace), 2000 ether);

        vm.prank(buyer);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        marketplace.buyItem(itemId);
    }
}
