// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/Token.sol";
import "../contracts/Marketplace.sol";

contract DeployScript is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;

    function setUp() public {}

    function run() public {
        // Begin broadcasting transactions
        vm.startBroadcast();

        // Deploy Token contract
        Token token = new Token("Marketplace Token", "MKT");
        console2.log("Token deployed to:", address(token));

        // Mint some initial tokens to the deployer
        token.mint(msg.sender, INITIAL_SUPPLY);
        console2.log("Minted tokens to deployer:", msg.sender);
        console2.log("Amount:", INITIAL_SUPPLY);

        // Deploy Marketplace contract with the token address
        Marketplace marketplace = new Marketplace(address(token));
        console2.log("Marketplace deployed to:", address(marketplace));

        // Approve the marketplace to spend tokens
        token.approve(address(marketplace), type(uint256).max);
        console2.log("Marketplace approved for token spending.");

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
