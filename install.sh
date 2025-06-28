#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Installing Moonlight Wrapper…"

# 1) Ensure your personal bin directory exists
mkdir -p "$HOME/bin"

# 2) Install the wrapper script
install -m 0755 wrapper.sh "$HOME/bin/moonlight" \
  && echo "  ✔ Installed wrapper to $HOME/bin/moonlight"

# 3) Install the desktop entry override (now containing fallback logic)
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
cp moonlight.desktop \
   "$DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop" \
   && echo "  ✔ Installed desktop override"

# 4) Update desktop database
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR" \
    && echo "  ✔ Refreshed desktop database"
else
  echo "  ↷ update-desktop-database not found, skipping"
fi

echo -e "\n✅ Install complete."

cat <<EOF

Next steps:

1. In Steam Desktop Mode → Games → Add a Non-Steam Game → Browse to “$HOME/bin/moonlight” → Add.  
2. In MoonDeck’s settings, point “Moonlight executable” to:
   $HOME/bin/moonlight  

Now every launch—terminal, menu, Game Mode or shortcut—will refresh your fps= setting automatically.  

EOF
