# Battle Royale Game

## Project Description

Battle Royale Game is a decentralized smart contract-based gaming platform that brings the excitement of last-player-standing battles to the blockchain. Players pay an entry fee to join matches where they compete to eliminate each other until only one survivor remains. The winner takes home the entire prize pool (minus a small platform fee), creating an engaging and rewarding gaming experience powered by Ethereum smart contracts.

The game implements a simple yet thrilling combat system where players can attack each other with randomized outcomes, ensuring fair gameplay while maintaining the unpredictable nature that makes battle royale games exciting. Each match supports 3-10 players and features automatic game state management, secure prize distribution, and transparent elimination tracking.

## Project Vision

Our vision is to revolutionize online gaming by creating a trustless, transparent, and decentralized gaming ecosystem where players have complete ownership of their gaming experience. By leveraging blockchain technology, we aim to eliminate traditional gaming intermediaries, ensure fair play through verifiable randomness, and provide players with true ownership of their achievements and rewards.

We envision Battle Royale Game as the foundation for a broader decentralized gaming metaverse where players can compete, earn, and build communities without relying on centralized gaming platforms. Our goal is to prove that blockchain gaming can be both entertaining and financially rewarding while maintaining the competitive spirit that drives the gaming community.

## Key Features

### 🎮 **Decentralized Gameplay**
- Fully on-chain game logic with no centralized servers
- Transparent and verifiable game outcomes
- Automatic match-making and game state management

### 💰 **Prize Pool System**
- Entry fee: 0.01 ETH per player
- Winner takes home 95% of the total prize pool
- 5% platform fee for development and maintenance
- Secure and automatic prize distribution

### ⚔️ **Combat Mechanics**
- Randomized battle outcomes using blockchain entropy
- 50% success rate for attacks to ensure balanced gameplay
- Instant elimination system with real-time updates
- Prevention of self-attacks and invalid targets

### 🏆 **Game Management**
- Support for 3-10 players per match
- Automatic game creation and joining system
- Real-time tracking of active players and eliminations
- Emergency game resolution for stuck matches

### 🔒 **Security Features**
- Multi-signature patterns for critical functions
- Input validation and access control
- Emergency functions for edge cases
- Owner-only administrative controls

### 📊 **Transparency**
- Complete game history stored on-chain
- Public access to game statistics and player data
- Event emission for all major game actions
- Verifiable random number generation

## Future Scope

### 🚀 **Immediate Enhancements (Phase 1)**
- **Multiple Game Modes**: King of the Hill, Team Battles, Tournament Brackets
- **Advanced Combat System**: Weapon selection, armor, special abilities
- **Player Statistics**: Win/loss ratios, kill/death tracking, leaderboards
- **Mobile DApp**: React Native application for mobile gaming

### 🌟 **Medium-term Development (Phase 2)**
- **NFT Integration**: Collectible weapons, skins, and battle passes
- **Staking Rewards**: Passive income for holding game tokens
- **Guild System**: Team formation, shared rewards, guild battles
- **Cross-chain Support**: Polygon, BSC, and other EVM-compatible chains

### 🎯 **Long-term Vision (Phase 3)**
- **3D Battle Arena**: Integration with virtual worlds and metaverse platforms
- **AI-powered NPCs**: Computer-controlled enemies and allies
- **Streaming Integration**: Twitch/YouTube live streaming rewards
- **Esports Platform**: Professional tournaments with large prize pools

### 💡 **Advanced Features (Phase 4)**
- **Layer 2 Integration**: Gas-efficient gameplay on Optimism/Arbitrum
- **DAO Governance**: Community-driven game development decisions
- **Play-to-Earn Economy**: Sustainable tokenomics with earning mechanisms
- **Interoperability**: Cross-game asset usage and shared economies

### 🔧 **Technical Improvements**
- **Oracle Integration**: Chainlink VRF for true randomness
- **Gas Optimization**: State packing and efficient storage patterns
- **Upgradeable Contracts**: Proxy patterns for feature additions
- **Advanced Security**: Formal verification and comprehensive audits

---

## Getting Started

### Prerequisites
- Node.js (v16 or higher)
- Hardhat or Truffle development environment
- MetaMask or similar Web3 wallet
- Test ETH for deployment and testing

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/battle-royale-game.git

# Navigate to project directory
cd battle-royale-game

# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to testnet
npx hardhat run scripts/deploy.js --network goerli
```

### Usage
1. Deploy the contract to your preferred network
2. Players call `joinGame()` with 0.01 ETH to enter matches
3. Once 3+ players join, the game automatically starts
4. Players use `attackPlayer()` to eliminate opponents
5. The last surviving player calls `claimPrize()` to receive rewards

---

**Join the battle, prove your skills, and claim your victory on the blockchain!** 🏆


## Contract Details  : 0x95c00E4f1b4C7aE05ae807E72e36547Ea059d366
<img width="1743" height="830" alt="Screenshot 2025-07-28 142334" src="https://github.com/user-attachments/assets/5a3bbf15-8231-420b-bd70-ebbdabbbd00f" />
