# 🚀 Flipper DEX Testnet Bot

> **Automated bot for [Flipper DEX](https://app.flpp.io) testnet — perps trading via tRPC API on Solana devnet**

No browser. No extension. Just pure terminal automation.

## ✨ Features

| Feature | Status |
|---------|--------|
| 🔐 Auth (challenge → sign → JWT) | ✅ |
| 💰 Balance check (SOL + tokens) | ✅ |
| 📊 Perps quotes (SOL, BTC, ETH...) | ✅ |
| 📦 Deposit collateral | ✅ |
| 🎯 Open positions (long/short) | ✅ |
| ❌ Close positions | ✅ |
| 📋 Portfolio overview | ✅ |
| 🎁 Quest/rewards status | ⏳ |

## 🏗️ Architecture

```
┌─────────────┐     ┌──────────────────┐     ┌──────────────┐
│  flipper.py  │────▶│  tRPC API        │────▶│  Flipper     │
│  (your bot)  │     │  perps-api-devnet│     │  Backend     │
└─────────────┘     │  .flpp.io/trpc   │     └──────┬───────┘
                    └──────────────────┘            │
                                                    ▼
┌─────────────┐     ┌──────────────────┐     ┌──────────────┐
│  Solana CLI │────▶│  Devnet RPC      │────▶│  On-chain    │
│  keypair    │     │  api.devnet      │     │  Programs    │
└─────────────┘     │  .solana.com     │     └──────────────┘
                    └──────────────────┘
```

## 📦 Requirements

```bash
pip install solders base58
```

## 🚀 Quick Start

### 1️⃣ Set up your wallet

```bash
# Export your Solana private key (base58)
export SOLANA_PRIVATE_KEY="your_base58_private_key_here"

# Or create a .env file
echo "SOLANA_PRIVATE_KEY=your_key_here" > .env
```

### 2️⃣ Run the bot

```bash
# Auth + Full testnet farming
python flipper.py farm

# Quick balance check
python flipper.py balance

# Get perps quotes (SOL-PERP)
python flipper.py quotes SOL-PERP

# Open a long position ($10, 1x leverage)
python flipper.py open SOL-PERP long 10 1

# Check your portfolio
python flipper.py portfolio
```

## 🧪 Testnet Details

| Parameter | Value |
|-----------|-------|
| **Network** | Solana devnet |
| **tRPC API** | `https://perps-api-devnet-staging.flpp.io/trpc` |
| **Solana RPC** | `https://api.devnet.solana.com` |
| **Auth** | Wallet-based (challenge → sign → JWT) |
| **DEXes** | Jupiter, Drift, FlashTrade, Adrena, GMTrade |
| **Perps markets** | SOL, BTC, ETH, DOGE, WIF, JUP, BONK... |
| **Currencies** | EUR/USD, GBP/USD, Gold, Oil (DeForex) |

## 📸 Example Output

```
$ python flipper.py quotes SOL-PERP

🔑 Wallet: 7ejfu8pAFNYDm2JQR7rU4R9XGEK9Q5gj3xYJVY3T6kyq
✅ JWT: eyJhbG... (authenticated)
💰 Devnet: 22.09 SOL | 14 tokens

📊 SOL-PERP Quotes:
┌──────────┬──────────┬──────────┬──────────┐
│ DEX      │   Bid    │   Ask    │  Liq.    │
├──────────┼──────────┼──────────┼──────────┤
│ Jupiter  │ $67.93   │ $67.94   │ $450M    │
│ Flash    │ $67.92   │ $67.95   │ $120M    │
│ Drift    │ $67.91   │ $67.94   │ $300M    │
└──────────┴──────────┴──────────┴──────────┘

💎 Best ask: Jupiter at $67.94
```

## 🔧 Development

```bash
# Clone
git clone https://github.com/Devin1-tri/flipper-bot
cd flipper-bot

# Install
pip install -r requirements.txt

# Run tests
pytest tests/
```

## ⚠️ Disclaimer

This bot is for **educational and testnet purposes only**. Use at your own risk. The author is not responsible for any financial losses incurred from using this software.

---

Built with 🔥 by [@0xrizvan](https://x.com/0xrizvan)
