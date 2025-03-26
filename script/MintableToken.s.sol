// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {MintableToken} from "../src/MintableToken.sol";

contract MintableTokenScript is Script {
    // Configuration - make these public to help with verification
    string public name = "MyToken";
    string public symbol = "MTK";
    uint256 public initialSupply = 1_000_000 * 10**18; // 1 million tokens with 18 decimals
    uint256 public cap = 10_000_000 * 10**18; // 10 million tokens cap
    
    function run() public {
        uint256 deployerPrivateKey;
        
        // Try to get private key from environment variable, use a default for simulation if not found
        try vm.envUint("PRIVATE_KEY") returns (uint256 privateKey) {
            deployerPrivateKey = privateKey;
        } catch {
            // Use a default private key for simulation only (not secure for production!)
            deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        }
        
        address deployerAddress = vm.addr(deployerPrivateKey);
        
        // Output information to console
        console2.log("Deploying MintableToken:");
        console2.log("  Name: ", name);
        console2.log("  Symbol: ", symbol);
        console2.log("  Initial Supply: ", initialSupply / 10**18, " tokens");
        console2.log("  Cap: ", cap / 10**18, " tokens");
        console2.log("  Owner: ", deployerAddress);
        
        // Prepare constructor arguments for verification
        string memory constructorArgs = string.concat(
            "$(cast abi-encode \"constructor(string,string,uint256,address,uint256)\" ",
            "\"", name, "\" ",
            "\"", symbol, "\" ",
            vm.toString(initialSupply), " ",
            addressToString(deployerAddress), " ",
            vm.toString(cap), ")"
        );
        
        console2.log("For verification, use these constructor arguments:");
        console2.log(constructorArgs);
        
        vm.startBroadcast(deployerPrivateKey);
        
        MintableToken token = new MintableToken(
            name,
            symbol,
            initialSupply,
            deployerAddress,
            cap
        );
        
        string memory deployedAddress = addressToString(address(token));
        console2.log("Token deployed at: ", address(token));
        
        vm.stopBroadcast();
        
        // Print a complete verification command
        string memory verificationCommand = string.concat(
            "forge verify-contract --chain-id <CHAIN_ID> --watch ",
            deployedAddress,
            " src/MintableToken.sol:MintableToken ",
            "--constructor-args ", constructorArgs, " ",
            "--etherscan-api-key <YOUR_API_KEY>"
        );
        
        console2.log("\nVerification command example:");
        console2.log(verificationCommand);
    }
    
    // Helper functions for string conversion
    function addressToString(address _addr) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = "0";
        s[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(_addr)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 + 2 * i] = char(hi);
            s[2 + 2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
    
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}