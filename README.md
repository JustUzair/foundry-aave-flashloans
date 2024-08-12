## Fork Test Foundry Script

```bash
forge test -vvvv --rpc-url eth_sepolia
```

### AAVE Testnet Faucet

- [Get Test Tokens Here](https://staging.aave.com/faucet/)

### Testing FlashLoan

- This command tests both USDC and DAI FlashLoan
  - To test with other tokens, use the link above for the faucet, mint test tokens and add to `HelperConfig.s.sol`
  - Copy and paste the other flash loan test & replace with the address of token you want to test.

```bash
forge test -vvvv --mt test_simpleFlashLoan
```

## Refer to Address on Different Network in [HelperConfig.s.sol](./script/HelperConfig.s.sol)

- [USDC on Etherscan Sepolia Testnet](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)
- [DAI on Etherscan Sepolia Testnet](https://sepolia.etherscan.io/address/0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357)
- [All Testnet Addresses](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses)

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
