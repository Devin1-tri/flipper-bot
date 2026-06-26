#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# Flipper Bot — Daily Farming Routine
# Runs automatically via cron to farm XP every day
# ═══════════════════════════════════════════════════════════════════════════════

BOT_DIR="/home/azureuser/bot/flipper-bot"
LOG_DIR="$BOT_DIR/logs"
DATE=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/farm-$DATE.log"
STREAK_FILE="$LOG_DIR/streak.txt"

mkdir -p "$LOG_DIR"

export SOLANA_PRIVATE_KEY="3CUCQToE7Wg99cn8pBmN9aSwFgeapYhMbaPQyzwJRTPhNWgMVkGHxCYuMLmXXuUT4FieRrUAhRvgcanjcyVs3CiF"
export FLIPPER_API="https://perps-api-devnet-staging.flpp.io/trpc"
export SOLANA_RPC="https://api.devnet.solana.com"

cd "$BOT_DIR"

exec >> "$LOG_FILE" 2>&1

echo "══════════════════════════════════════════════"
echo "  🌾 FLIPPER DAILY FARM — $(date)"
echo "══════════════════════════════════════════════"

# ── STEP 1: Balance Check ──
echo ""
echo "[1/5] 📊 Balance check..."
python3 flipper.py balance

# ── STEP 2: Farm (auth + scan + portfolio) ──
echo ""
echo "[2/5] 🌾 Farm check..."
python3 flipper.py farm

# ── STEP 3: Daily Trade (open + close) ──
echo ""
echo "[3/5] 💹 Daily Trade — opening SOL-PERP long..."
python3 flipper.py open SOL-PERP long 10 1

echo ""
echo "[3b/5] Closing position..."
python3 flipper.py portfolio

# ── STEP 4: Track Streak ──
echo ""
echo "[4/5] 📅 Streak tracker..."
if [ -f "$STREAK_FILE" ]; then
    LAST_DATE=$(cat "$STREAK_FILE")
    DIFF=$(( ( $(date -d "$DATE" +%s) - $(date -d "$LAST_DATE" +%s) ) / 86400 ))
    if [ "$DIFF" -eq 1 ]; then
        echo "  ✅ Streak continued! Last: $LAST_DATE"
    elif [ "$DIFF" -gt 1 ]; then
        echo "  ⚠️ Streak broken! Last: $LAST_DATE ($DIFF days gap)"
    else
        echo "  ⚠️ Already done today ($LAST_DATE)"
    fi
else
    echo "  🆕 First day!"
fi
echo "$DATE" > "$STREAK_FILE"

# ── STEP 5: Summary ──
echo ""
echo "[5/5] ✅ Daily farming complete!"
echo "  Time: $(date)"
echo "  Log: $LOG_FILE"
echo "══════════════════════════════════════════════"
