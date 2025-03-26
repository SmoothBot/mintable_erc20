// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MintableToken} from "../src/MintableToken.sol";

contract MintableTokenTest is Test {
    MintableToken public token;
    
    address public owner;
    address public user1;
    address public user2;
    
    uint256 public initialSupply = 1_000_000 * 10**18; // 1 million tokens with 18 decimals
    uint256 public cap = 10_000_000 * 10**18; // 10 million tokens cap
    
    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        // Deploy token with initial supply and cap
        token = new MintableToken(
            "MyToken",
            "MTK",
            initialSupply,
            owner,
            cap
        );
        
        // Fund test users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }
    
    function test_InitialState() public {
        assertEq(token.name(), "MyToken");
        assertEq(token.symbol(), "MTK");
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(owner), initialSupply);
        assertEq(token.owner(), owner);
        assertEq(token.cap(), cap);
    }
    
    function test_Mint() public {
        uint256 mintAmount = 100 * 10**18;
        token.mint(user1, mintAmount);
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), initialSupply + mintAmount);
    }
    
    function test_MintFailsWhenNotOwner() public {
        vm.startPrank(user1);
        vm.expectRevert();
        token.mint(user1, 100 * 10**18);
        vm.stopPrank();
    }
    
    function test_MintFailsWhenExceedingCap() public {
        uint256 remainingToMint = cap - initialSupply;
        
        // Try to mint more than the cap allows
        vm.expectRevert();
        token.mint(user1, remainingToMint + 1);
        
        // Should succeed when minting exactly up to the cap
        token.mint(user1, remainingToMint);
        assertEq(token.totalSupply(), cap);
    }
    
    function test_Transfer() public {
        uint256 transferAmount = 100 * 10**18;
        token.transfer(user1, transferAmount);
        
        assertEq(token.balanceOf(user1), transferAmount);
        assertEq(token.balanceOf(owner), initialSupply - transferAmount);
    }
    
    function test_Burn() public {
        uint256 burnAmount = 100 * 10**18;
        token.burn(burnAmount);
        
        assertEq(token.balanceOf(owner), initialSupply - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }
    
    function test_BurnFrom() public {
        uint256 transferAmount = 200 * 10**18;
        uint256 burnAmount = 100 * 10**18;
        
        // Transfer some tokens to user1
        token.transfer(user1, transferAmount);
        
        // User1 approves user2 to burn tokens
        vm.prank(user1);
        token.approve(user2, burnAmount);
        
        // User2 burns tokens from user1's account
        vm.prank(user2);
        token.burnFrom(user1, burnAmount);
        
        assertEq(token.balanceOf(user1), transferAmount - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }
    
    function test_NoCap() public {
        // Deploy token without a cap (cap = 0)
        MintableToken uncappedToken = new MintableToken(
            "UncappedToken",
            "UNC",
            initialSupply,
            owner,
            0
        );
        
        // Should return max uint256 for cap
        assertEq(uncappedToken.cap(), type(uint256).max);
        
        // Should be able to mint any amount
        uncappedToken.mint(user1, 100_000_000 * 10**18);
    }
}