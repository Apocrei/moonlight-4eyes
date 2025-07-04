#!/usr/bin/env bash
set -euo pipefail

# 1) ensure ~/bin exists
mkdir -p "$HOME/bin"

# 2) install the wrapper
install -m 0755 wrapper.sh "$HOME/bin/moonlight"

# 3) copy & patch the .desktop
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
sed "s|{{WRAPPER_PATH}}|$HOME/bin/moonlight|g" \
    moonlight.desktop \
  > "$DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop"

# 4) update desktop database if available
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR"
fi

echo -e "\n▶️  Launching Moonlight briefly to complete setup…"
flatpak run com.moonlight_stream.Moonlight &

sleep 5  # Give Moonlight time to open and write logs

echo "⏹️  Attempting to close Moonlight via Flatpak…"
flatpak kill com.moonlight_stream.Moonlight || true


cat <<EOF

✅ Installed wrapper to: $HOME/bin/moonlight
✅ Overrode .desktop in: $DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop

Next steps:

1. In Steam Desktop Mode → Games → Add a Non-Steam Game → Browse to “$HOME/bin/moonlight” → Add.
2. In MoonDeck’s settings, point “Moonlight executable” to:
   $HOME/bin/moonlight

Now every launch—terminal, menu, Game Mode or shortcut—will refresh your fps= setting automatically.

EOF
