# RARE – L1–L2 Review System

STARKNET_RPC may not work, create your own API key on https://alchemy.com

## Requirements

Ethereum:
- npm version 10.8.2
- npm packages: dotenv, starknet

Cairo / Starknet:
- starkli version 0.4.2
- JSON-RPC 0.8.1
- scarb 2.11.4

## L1–L2 Interaction

Ethereum (L1):

Deploy contracts:
npx hardhat run --network sepolia source/deploy.js

Send payment (L1 → L2):
npx hardhat run --network sepolia source/send.js

Consume message (L2 → L1):
npx hardhat run --network sepolia source/consume.js

Starknet (L2):

Contract deployed at address:
<L2_CONTRACT_ADDRESS>

Leave review:
node leavereview.js

## L1 Review Only (No Starknet)

Deploy contract:
npx hardhat run --network sepolia source_l1exp/deployReview.js

Leave review:
npx hardhat run --network sepolia source_l1exp/leave_ReviewL1.js