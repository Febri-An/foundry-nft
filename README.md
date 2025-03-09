# Foundry Static & Dynamic NFT

## Overview
This project demonstrates two types of NFT smart contracts built using Foundry:

1. **BasicNft** → A simple ERC-721 NFT where the image is predefined and cannot be changed.
2. **MoodNft** → A dynamic NFT that can change its appearance or attributes, such as switching between a "happy" and "sad" mood.

## Project Structure
```
foundry-nft/
│── src/               # Contains Solidity smart contracts
│   ├── BasicNft.sol   # Static NFT contract
│   ├── MoodNft.sol    # Dynamic NFT contract
│
│── test/              # Test scripts for the contracts
│── script/            # Deployment scripts
│── images/            # NFT image assets
│── foundry.toml       # Foundry configuration file
```

## Getting Started

### Prerequisites
Ensure you have Foundry installed. If not, install it with:
```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation
Clone this repository and install dependencies:
```sh
git clone https://github.com/Febri-An/foundry-nft.git
cd foundry-nft
forge install
```

### Compilation
Compile the smart contracts with:
```sh
forge build
```

### Running Tests
Run the test suite to ensure everything works correctly:
```sh
forge test
```

## Smart Contracts

### 1. BasicNft.sol
- Implements a simple ERC-721 NFT.
- The image URI is set at minting and cannot be changed.

### 2. MoodNft.sol
- Implements a dynamic NFT.
- Owners can toggle the NFT's mood (e.g., happy ↔ sad).
- Uses on-chain storage to manage the NFT state.

## Deployment
To deploy the contracts, use the Foundry script:
```sh
forge script script/DeployBasicNft.s.sol --broadcast --rpc-url <RPC_URL>
```
or
```sh
forge script script/DeployMoodNft.s.sol --broadcast --rpc-url <RPC_URL>
```
Replace `<RPC_URL>` with your blockchain provider URL (e.g., Alchemy, Infura, or Anvil for local testing).

## Interaction
You can directly mint NFT or change the Mood NFT through your terminal or console programatically using Makefile.
look [here]("https://github.com/Febri-An/foundry-nft/blob/main/Makefile").

## License
This project is licensed under the MIT License.

