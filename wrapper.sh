#!/usr/bin/env bash
#
# wrapper.sh – detect, round refresh rate → update Moonlight.conf → launch Moonlight
#

# 1) get float refresh rate, then round
RATE=$(xrandr | grep -Po '\d+\.\d+(?=\*)' | head -n1)
FPS=$(printf "%.0f" "$RATE")

# 2) actual config path
CONF="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"

# 3) update fps=
if [ -f "$CONF" ]; then
  sed -i "s|^fps=.*|fps=$FPS|" "$CONF"
else
  echo "ERROR: Moonlight.conf not found at $CONF" >&2
fi

# 4) hand off to real Flatpak Moonlight
exec flatpak run com.moonlight_stream.Moonlight "$@"
