#!/usr/bin/env bash
set -euo pipefail

echo "🗑  Uninstalling Moonlight Wrapper…"

# 1) Remove the wrapper binary
if rm -fv "$HOME/bin/moonlight"; then
  echo "  ✔ Removed wrapper binary"
else
  echo "  ↷ No wrapper binary found, skipping"
fi

# 2) Remove the upstream override desktop file
DESKTOP_OVERRIDE="$HOME/.local/share/applications/com.moonlight_stream.Moonlight.desktop"
if rm -fv "$DESKTOP_OVERRIDE"; then
  echo "  ✔ Removed upstream desktop override"
else
  echo "  ↷ No upstream desktop override found, skipping"
fi

# 3) Remove the wrapper’s own desktop file
WRAPPER_DESKTOP="$HOME/.local/share/applications/moonlight.desktop"
if rm -fv "$WRAPPER_DESKTOP"; then
  echo "  ✔ Removed wrapper desktop file"
else
  echo "  ↷ No wrapper desktop file found, skipping"
fi

# 4) Strip fps= override from your Flatpak config
CONF="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"
if [ -f "$CONF" ]; then
  sed -i.bak '/^fps=/d' "$CONF"
  echo "  ✔ Stripped fps= lines (backup at $CONF.bak)"
else
  echo "  ↷ Config file not found, skipping fps cleanup"
fi

# 5) Update desktop database to remove stale entries
DESKTOP_DIR="$HOME/.local/share/applications"
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR"
  echo "  ✔ Refreshed desktop database"
else
  echo "  ↷ update-desktop-database not found, skipping desktop database update"
fi

# 6) Remove the backup config file created during uninstall
if rm -fv "$CONF.bak"; then
  echo "  ✔ Removed config backup file"
else
  echo "  ↷ No config backup file found, skipping"
fi

# 7) Remove the bin folder if it’s now empty
if rmdir --ignore-fail-on-non-empty "$HOME/bin"; then
  echo "  ✔ Removed empty ~/bin directory"
else
  echo "  ↷ ~/bin not empty or not present, skipping"
fi

echo -e "\n✅ Uninstall complete."
