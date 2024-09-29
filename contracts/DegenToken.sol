// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    // Constructor now properly initializes both ERC20 and Ownable contracts
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        // You can add initial minting logic here if needed
        _mint(msg.sender, 1000 * 10 ** decimals()); // Minting some initial tokens for the owner
    }

    // Function 1: Minting new tokens (onlyOwner can mint tokens)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function 2: Transferring tokens between players
    function transferTokens(address recipient, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, recipient, amount);
    }

    // Function 3: Redeeming tokens for in-game store items
    function redeemTokens(uint choice) external {
        require(choice >= 1 && choice <= 3, "Invalid selection");

        uint cost;
        if (choice == 1) {
            cost = 100;  // Instagram
        } else if (choice == 2) {
            cost = 75;   // Whatsapp
        } else {
            cost = 50;   // Snapchat
        }

        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem");
        _transfer(msg.sender, owner(), cost);  // Transferring tokens to owner
    }

    // Function 4: Checking the token balance
    function checkBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Function 5: Burning tokens
    function burnTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        burn(amount);
    }

    // In-game store listing for reference (pure function)
    function viewStore() public pure returns (string memory) {
        return "1. Instagram = 100 Tokens\n2. Whatsapp = 75 Tokens\n3. Snapchat = 50 Tokens";
    }
}

