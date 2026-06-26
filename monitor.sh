#!/bin/bash
# Flipper Bot — Screen Launcher
# Run: screen -S flipper ./monitor.sh
# Detach: Ctrl+A, D
# Reattach: screen -r flipper

cd /home/azureuser/bot/flipper-bot

echo "══════════════════════════════════════════════"
echo "  🌾 FLIPPER BOT MONITOR"
echo "  ⏰ $(date)"
echo "  📋 Live log tail (auto-refresh every 30s)"
echo "══════════════════════════════════════════════"
echo ""

while true; do
    LATEST=$(ls -t logs/farm-*.log 2>/dev/null | head -1)
    if [ -f "$LATEST" ]; then
        echo "── Latest log: $LATEST ──"
        tail -20 "$LATEST"
    else
        echo "No logs yet. Running first farm..."
        bash daily.sh
    fi
    echo ""
    echo "── Next update in 30s (Ctrl+C to stop) ──"
    sleep 30
done
