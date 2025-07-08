# uninstall.sh
#!/usr/bin/env bash
set -euo pipefail

echo "🗑 Uninstalling Moonlight Wrapper…"

# 1) Remove the wrapper binary
if rm -fv "$HOME/bin/moonlight"; then
  echo "  ✔ Removed wrapper binary"
else
  echo "  ↷ No wrapper binary found, skipping"
fi

# 2) Remove the desktop override
DESKTOP_OVERRIDE="$HOME/.local/share/applications/com.moonlight_stream.Moonlight.desktop"
if rm -fv "$DESKTOP_OVERRIDE"; then
  echo "  ✔ Removed desktop override"
else
  echo "  ↷ No desktop override found, skipping"
fi

# 3) restore original fps (if backed up)
CONF="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"
BAK="${CONF}.fpsbak"
if [[ -f "$BAK" ]]; then
  original_line=$(<"$BAK")
  if grep -q '^fps=' "$CONF"; then
    sed -i "s|^fps=.*|$original_line|" "$CONF"
  else
    echo "$original_line" >> "$CONF"
  fi
  rm -f "$BAK"
  echo "  ✔ Restored original fps setting from backup"
else
  echo "  ↷ No fps backup found, skipping fps restore"
fi

# 4) update desktop database
DESKTOP_DIR="$HOME/.local/share/applications"
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR"
  echo "  ✔ Refreshed desktop database"
else
  echo "  ↷ update-desktop-database not found, skipping"
fi

echo -e "\n✅ Uninstall complete."
