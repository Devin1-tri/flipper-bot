"""Tests for Flipper bot."""
import json
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

# Mock imports for testing
try:
    from flipper import PERPS_MARKETS, DEFOREX_MARKETS, load_wallet
except ImportError:
    PERPS_MARKETS = []
    DEFOREX_MARKETS = []


def test_markets_exist():
    """Test that market lists are populated."""
    assert len(PERPS_MARKETS) > 0, "No perps markets defined"
    assert "SOL-PERP" in PERPS_MARKETS, "SOL-PERP missing"
    assert len(DEFOREX_MARKETS) > 0, "No deforex markets defined"
    print(f"✅ {len(PERPS_MARKETS)} perps markets, {len(DEFOREX_MARKETS)} deforex markets")


def test_auth_flow():
    """Test that auth flow is properly structured (integration test only with real key)."""
    key = os.getenv("SOLANA_PRIVATE_KEY", "")
    if not key:
        print("⚠️ No SOLANA_PRIVATE_KEY set — skipping auth test")
        print("   Set the env var to run integration tests")
        return

    from flipper import TRPCClient, authenticate
    from solders.keypair import Keypair
    import base58

    seed = base58.b58decode(key)
    kp = Keypair.from_bytes(seed)
    pubkey = str(kp.pubkey())

    rpc = TRPCClient("https://perps-api-devnet-staging.flpp.io/trpc")
    jwt = authenticate(rpc, kp, pubkey)

    assert jwt and len(jwt) > 20, "JWT too short"
    assert rpc.token == jwt, "Token not stored in client"
    print(f"✅ Auth OK — JWT: {jwt[:30]}...")


def test_quotes():
    """Test fetching perps quotes (integration test)."""
    key = os.getenv("SOLANA_PRIVATE_KEY", "")
    if not key:
        print("⚠️ No SOLANA_PRIVATE_KEY set — skipping quotes test")
        return

    from flipper import TRPCClient, authenticate, get_quotes
    from solders.keypair import Keypair
    import base58

    seed = base58.b58decode(key)
    kp = Keypair.from_bytes(seed)
    pubkey = str(kp.pubkey())

    rpc = TRPCClient("https://perps-api-devnet-staging.flpp.io/trpc")
    authenticate(rpc, kp, pubkey)

    quotes = get_quotes(rpc, "SOL-PERP")
    assert len(quotes) > 0, "No quotes returned"
    assert "dexId" in quotes[0], "Missing dexId"
    assert "quote" in quotes[0], "Missing quote"
    print(f"✅ Quotes: {len(quotes)} DEXes — Best ask: ${quotes[0]['quote']['askPrice']:.2f}")


if __name__ == "__main__":
    test_markets_exist()
    test_auth_flow()
    test_quotes()
    print("\n✅ All tests passed!")
