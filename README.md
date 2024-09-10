# Ethernaut Capture the Flag with Foundry 🧑‍💻🏴‍☠️

This project is dedicated to solving [Ethernaut](https://ethernaut.openzeppelin.com/) exercises using [Foundry](https://getfoundry.sh/). Each level from Ethernaut will have its own contract, test, and deployment script. This repo is for personal purposes, te learn about Foundry while practicing Solidity.

## Project Structure 🏗️

```bash
ethernaut-foundry/
├── src/             # Contains the Solidity contracts for each level
│   ├── level1/
│   │   └── Level1.sol
│   ├── level2/
│   │   └── Level2.sol
│   └── ...
├── test/            # Tests written in Solidity for each level
│   ├── level1/
│   │   └── Level1.t.sol
│   ├── level2/
│   │   └── Level2.t.sol
│   └── ...
├── scripts/         # Deployment and interaction scripts
│   └── DeployLevel1.s.sol
├── foundry.toml     # Foundry configuration file
├── .gitignore       # Ignored files for version control
└── README.md        # This file!
```

## Installation & Setup 🛠️

### Prerequisites

Foundry installed (foundryup command available)
Git and a GitHub account

### Steps

1. Clone the repository:

```bash
git clone https://github.com/banasa44/ethernaut-Foundry.git
cd my-ethernaut
```

2. Install dependencies:

```bash
forge install
```

3. Build the contracts:

```bash
forge build
```

4. Run tests:

```bash
forge test
```

## Solving Ethernaut Levels 🔐

Each level in Ethernaut is represented by a folder under src/ and test/. The solution process will involve writing:

- A contract representing the challenge from Ethernaut.
- A test for solving and verifying the challenge.
- (Optionally) a script to automate deployment and interaction with the contract on a live testnet (like Sepolia).
