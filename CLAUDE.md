# Foundry Project Guidelines

## Build & Test Commands
- Build project: `forge build`
- Run all tests: `forge test`
- Run single test: `forge test --match-test testFunctionName`
- Run tests with verbosity: `forge test -vvv`
- Format code: `forge fmt`
- Gas snapshots: `forge snapshot`
- Deploy script: `forge script script/ScriptName.s.sol:ContractScript --rpc-url <url> --private-key <key>`
- Local node: `anvil`

## Code Style Guidelines
- SPDX license identifier required: `// SPDX-License-Identifier: UNLICENSED`
- Solidity version: ^0.8.13
- Import format: `import {Contract} from "path/to/Contract.sol"`
- Contract layout: events, state variables, modifiers, constructor, functions (external/public/internal/private)
- Naming: PascalCase for contracts/interfaces, camelCase for functions/variables
- Test prefix: `test_` for regular tests, `testFuzz_` for fuzz tests
- Error handling: use custom errors instead of require statements where possible
- Use forge-std's console for debugging: `import {console} from "forge-std/console.sol"`
- Follow standard Foundry project structure (src/, test/, script/)