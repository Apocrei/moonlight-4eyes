#!/usr/bin/env bash
set -euo pipefail

echo "🗑  Uninstalling Moonlight Wrapper…"

# 1) Remove the wrapper binary
if rm -fv "$HOME/bin/moonlight"; then
  echo "  ✔ Removed wrapper binary"
else
  echo "  ↷ No wrapper binary found, skipping"
fi

# 2) Remove the desktop override
DESKTOP="$HOME/.local/share/applications/com.moonlight_stream.Moonlight.desktop"
if rm -fv "$DESKTOP"; then
  echo "  ✔ Removed desktop override"
else
  echo "  ↷ No desktop override found, skipping"
fi

# 3) Strip fps= override from your Flatpak config
CONF="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"
if [ -f "$CONF" ]; then
  sed -i.bak '/^fps=/d' "$CONF"
  echo "  ✔ Stripped fps= lines (backup at $CONF.bak)"
else
  echo "  ↷ Config file not found, skipping fps cleanup"
fi

echo -e "\n✅ Uninstall complete."
echo "▶ To launch native Moonlight from now on, run:"
echo "   flatpak run com.moonlight_stream.Moonlight"
