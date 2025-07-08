# install.sh
#!/usr/bin/env bash
set -euo pipefail

# 1) ensure ~/bin exists
mkdir -p "$HOME/bin"

# 2) install the wrapper
install -m 0755 wrapper.sh "$HOME/bin/moonlight"

# 3) determine display FPS
RATE=$(xrandr | grep -Po '\d+\.\d+(?=\*)' | head -n1)
DISPLAY_FPS=$(printf '%s' "${RATE:-60}")

# 4) backup original fps line (once)
CONF_DIR="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project"
CONF="$CONF_DIR/Moonlight.conf"
mkdir -p "$CONF_DIR"

if [[ -f "$CONF" ]] && [[ ! -f "${CONF}.fpsbak" ]]; then
  if grep -q '^fps=' "$CONF"; then
    grep '^fps=' "$CONF" > "${CONF}.fpsbak"
    echo "BOOTSTRAP: backed up original fps to ${CONF}.fpsbak"
  fi
fi

# 5) ensure fps= is set to DISPLAY_FPS
if grep -q '^fps=' "$CONF"; then
  sed -i "s/^fps=.*/fps=$DISPLAY_FPS/" "$CONF"
else
  echo "fps=$DISPLAY_FPS" >> "$CONF"
fi
echo "BOOTSTRAP: set fps=$DISPLAY_FPS in $CONF"

# 6) install & patch the .desktop
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
sed "s|{{WRAPPER_PATH}}|$HOME/bin/moonlight|g" \
    moonlight.desktop \
  > "$DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop"

# 7) update desktop database if available
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR"
  echo "Database updated…"
else
  echo "Bypassed database update…"
fi

cat <<EOF

✅ Installed wrapper to: $HOME/bin/moonlight
✅ Overrode .desktop in: $DESKTOP_DIR/com.moonlight_stream.Moonlight.desktop

EOF
