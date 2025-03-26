// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title MintableToken
 * @dev Implementation of an ERC20 token with minting capabilities restricted to the owner.
 */
contract MintableToken is ERC20, Ownable {
    // Custom errors
    error MintingLimitExceeded(uint256 amount, uint256 limit);

    // Optional cap on total supply
    uint256 private immutable _cap;
    bool private immutable _hasCap;

    /**
     * @dev Constructor sets the token name, symbol, initial supply, and initial owner.
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     * @param initialSupply The initial supply of tokens to mint to the owner
     * @param initialOwner The address that will be granted ownership of the contract
     * @param cap_ Optional cap on total supply (0 for no cap)
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply,
        address initialOwner,
        uint256 cap_
    ) ERC20(name_, symbol_) Ownable(initialOwner) {
        _hasCap = cap_ > 0;
        _cap = cap_;

        // Mint initial supply if specified
        if (initialSupply > 0) {
            _mint(initialOwner, initialSupply);
        }
    }

    /**
     * @dev Returns the cap on the token's total supply, if one is set.
     * @return The cap on total supply, or type(uint256).max if no cap is set
     */
    function cap() public view returns (uint256) {
        return _hasCap ? _cap : type(uint256).max;
    }

    /**
     * @dev Creates new tokens and assigns them to the specified account.
     * Can only be called by the contract owner.
     * @param to The account that will receive the created tokens
     * @param amount The amount of tokens to create
     */
    function mint(address to, uint256 amount) public onlyOwner {
        // Check if a cap exists and if it would be exceeded
        if (_hasCap && totalSupply() + amount > _cap) {
            revert MintingLimitExceeded(amount, _cap - totalSupply());
        }
        
        _mint(to, amount);
    }

    /**
     * @dev Burns tokens from the caller's account.
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Burns tokens from a specific account (with allowance).
     * @param account The account from which tokens will be burned
     * @param amount The amount of tokens to burn
     */
    function burnFrom(address account, uint256 amount) public {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount, true);
        }
        _burn(account, amount);
    }
}