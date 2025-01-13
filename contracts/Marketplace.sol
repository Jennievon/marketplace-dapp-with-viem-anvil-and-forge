// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Marketplace {
    using SafeERC20 for IERC20;

    struct Item {
        uint256 id;
        address seller;
        string name;
        string description;
        uint256 price;
        bool active;
    }

    IERC20 public immutable paymentToken;
    uint256 public itemCount;
    mapping(uint256 => Item) public items;
    uint256[] public activeItemIds;

    event ItemListed(
        uint256 indexed id,
        address indexed seller,
        string name,
        uint256 price
    );
    event ItemSold(
        uint256 indexed id,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );
    event ItemDelisted(uint256 indexed id);

    constructor(address _paymentToken) {
        require(_paymentToken != address(0), "Invalid token address");
        paymentToken = IERC20(_paymentToken);
    }

    function listItem(
        string calldata _name,
        string calldata _description,
        uint256 _price
    ) external returns (uint256) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_price > 0, "Price must be greater than 0");

        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            seller: msg.sender,
            name: _name,
            description: _description,
            price: _price,
            active: true
        });
        activeItemIds.push(itemCount);

        emit ItemListed(itemCount, msg.sender, _name, _price);
        return itemCount;
    }

    function buyItem(uint256 _id) external {
        Item storage item = items[_id];
        require(item.active, "Item not available");
        require(msg.sender != item.seller, "Cannot buy your own item");
        require(
            paymentToken.allowance(msg.sender, address(this)) >= item.price,
            "Insufficient allowance"
        );

        item.active = false;
        paymentToken.safeTransferFrom(msg.sender, item.seller, item.price);

        // Remove from activeItemIds
        for (uint256 i = 0; i < activeItemIds.length; i++) {
            if (activeItemIds[i] == _id) {
                activeItemIds[i] = activeItemIds[activeItemIds.length - 1];
                activeItemIds.pop();
                break;
            }
        }

        emit ItemSold(_id, item.seller, msg.sender, item.price);
    }

    function delistItem(uint256 _id) external {
        Item storage item = items[_id];
        require(item.seller == msg.sender, "Not the seller");
        require(item.active, "Item not active");

        item.active = false;

        for (uint256 i = 0; i < activeItemIds.length; i++) {
            if (activeItemIds[i] == _id) {
                activeItemIds[i] = activeItemIds[activeItemIds.length - 1];
                activeItemIds.pop();
                break;
            }
        }

        emit ItemDelisted(_id);
    }

    function getItem(uint256 _id) external view returns (Item memory) {
        return items[_id];
    }

    function getActiveItems() external view returns (Item[] memory) {
        uint256 activeCount = activeItemIds.length;
        Item[] memory activeItems = new Item[](activeCount);

        for (uint256 i = 0; i < activeCount; i++) {
            activeItems[i] = items[activeItemIds[i]];
        }

        return activeItems;
    }
}
