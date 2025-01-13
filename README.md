# Token-Based Marketplace dApp

A decentralized marketplace where users can list and purchase items using ERC20 tokens. Built with Foundry for smart contracts, Ponder for indexing, and React/Wagmi for the frontend.

## Features

- 🪙 Custom ERC20 token for marketplace transactions
- 📝 List items with name, description, and price
- 🛍️ Purchase items using tokens
- 🔄 Real-time updates via Ponder indexing
- 👛 Wallet integration with WalletConnect

## Tech Stack

- **Smart Contracts**: Solidity + Foundry
- **Indexing**: Ponder (WIP)
- **Frontend**: React + Viem/Wagmi
- **Styling**: TailwindCSS
- **Testing**: Forge

## Quick Start

1. Install dependencies:
```bash
npm install
```

2. Start local blockchain and deploy contracts:
```bash
# Terminal 1: Start Anvil
anvil

# Terminal 2: Deploy contracts
npm run deploy (forge script script/DeployScript.s.sol --fork-url http://localhost:8545 --broadcast)

# Optional: Deploy with private key (for testing)
npm run deploy:private [$PRIVATE_KEY] (forge script script/DeployScript.s.sol --fork-url http://localhost:8545 --broadcast --private-key $PRIVATE_KEY)
```

3. Start Ponder indexer:
```bash
# Terminal 3: Run indexer
npm run ponder:dev
```

4. Start frontend:
```bash
# Terminal 4: Run frontend
npm run dev
```

## Environment Setup

Create `.env` file:
```env
VITE_WALLETCONNECT_PROJECT_ID=your_project_id
```

## Contract Addresses (Local)

- Token: [$DEPLOYED_TOKEN_ADDRESS]
- Marketplace: [$DEPLOYED_MARKETPLACE_ADDRESS]

## Development Commands

```bash
# Smart Contracts
forge test          # Run tests
anvil --reset      # Reset local blockchain

# Frontend
npm run dev        # Start development server
npm run build      # Build for production

# Indexing
npm run ponder:dev # Start Ponder in development mode
```

## Local Network Setup

1. Add Local Network to MetaMask:
   - Network Name: `Anvil`
   - RPC URL: `http://127.0.0.1:8545`
   - Chain ID: `31337`
   - Currency Symbol: `GO`

2. Import Anvil Test Account:
   - Copy private key from Anvil output (first account)
   - In MetaMask: Click "Import Account"
   - Paste private key
   - Done!

## Project Structure

```
├── contracts/          # Solidity smart contracts
├── ponder/            # Ponder indexing configuration
├── src/
│   ├── components/    # React components
│   ├── config/       # App configuration
│   └── lib/          # Utilities and hooks
└── test/             # Contract tests
```

## License
MIT