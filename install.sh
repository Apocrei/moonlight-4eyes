#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Installing Moonlight Wrapper…"

# 1) Ensure your personal bin directory exists
mkdir -p "$HOME/bin"

# 2) Install the wrapper script
install -m 0755 wrapper.sh "$HOME/bin/moonlight" \
  && echo "  ✔ Installed wrapper to $HOME/bin/moonlight"

# 3) Install the desktop entry override with built-in fallback logic
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
cp moonlight.desktop.template \
   "$DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop" \
   && echo "  ✔ Installed desktop override"

# 4) Update desktop database so the menu picks up your override
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR" \
    && echo "  ✔ Refreshed desktop database"
else
  echo "  ↷ update-desktop-database not found, skipping desktop database update"
fi

echo -e "\n✅ Install complete. You can now launch Moonlight as usual."
