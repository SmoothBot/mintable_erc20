# Mintable ERC20 Token

A Foundry project implementing an ownable, mintable ERC20 token with optional supply cap.

## Features

- **Standard ERC20 Functionality**: Transfer, approve, and transferFrom methods
- **Ownable**: Owner has special rights for token administration
- **Minting**: Owner can create new tokens (with optional supply cap)
- **Burning**: Token holders can burn their own tokens
- **Capped Supply (Optional)**: Can set a maximum cap on token supply

## Project Structure

- `src/MintableToken.sol`: The main token contract
- `test/MintableToken.t.sol`: Tests for the token contract
- `script/MintableToken.s.sol`: Deployment script

## Usage

### Installation

```bash
git clone https://github.com/yourusername/mintable_erc20.git
cd mintable_erc20
forge install
```

### Build

```bash
forge build
```

### Test

```bash
forge test
```

### Deploy

1. Set up your environment variables:

```bash
export PRIVATE_KEY=your_private_key
export RPC_URL=your_rpc_url
export ETHERSCAN_API_KEY=your_etherscan_api_key  # Or equivalent explorer API key
```

2. Deploy:

```bash
forge script script/MintableToken.s.sol:MintableTokenScript --rpc-url $RPC_URL --broadcast
```

### Verify Contract on Block Explorer

The deploy script will print out the exact verification command to use, but here's the general format:

```bash
forge verify-contract --chain-id <CHAIN_ID> --watch \
  <CONTRACT_ADDRESS> \
  src/MintableToken.sol:MintableToken \
  --constructor-args $(cast abi-encode "constructor(string,string,uint256,address,uint256)" "MyToken" "MTK" 1000000000000000000000000 0xYourOwnerAddress 10000000000000000000000000) \
  --etherscan-api-key <YOUR_API_KEY>
```

Common chain IDs:
- Ethereum Mainnet: 1
- Goerli Testnet: 5
- Sepolia Testnet: 11155111
- BSC: 56
- Polygon: 137
- Optimism: 10
- Arbitrum: 42161
- Avalanche: 43114

For non-Etherscan block explorers, add the `--verifier-url` parameter:
```bash
# For Polygon
--verifier-url https://api.polygonscan.com/api
```

## Customize

You can customize the token by modifying the constructor parameters:

- `name`: Token name (e.g., "MyToken")
- `symbol`: Token symbol (e.g., "MTK")
- `initialSupply`: Initial token supply (in wei)
- `initialOwner`: Address of the initial owner
- `cap`: Maximum token supply cap (in wei, 0 for no cap)

## License

This project is licensed under the MIT License.