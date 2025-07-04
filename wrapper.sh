#!/usr/bin/env bash
#
# wrapper.sh – Moonlight FPS = display refresh (desktop) or parsed from steamui_system.txt (gaming)

: "${DEBUG:=false}"
debug(){ [ "$DEBUG" = true ] && echo "[D] $*" >&2; }

# 1) Detect display refresh rate
RATE=$(xrandr | grep -Po '\d+\.\d+(?=\*)' | head -n1)
DISPLAY_FPS=$(printf '%.0f' "${RATE:-0}")
echo "→ Display refresh rate = ${DISPLAY_FPS} fps"

# 2) Determine mode
if [[ "${SteamDeck:-0}" == "1" ]]; then
  echo "→ Mode: GAMING (SteamDeck=1)"
  MODE=gaming
else
  echo "→ Mode: DESKTOP"
  MODE=desktop
fi

# 3) Mode-specific logic
if [[ "$MODE" == "desktop" ]]; then
  FPS="$DISPLAY_FPS"
  echo "→ Chosen FPS = $FPS"
else
  # --- Inline moon-fps.sh logic ---
  VDF=$(find "$HOME/.local/share/Steam/userdata" -path '*/760/screenshots.vdf' -print0 \
        | xargs -0 ls -1t 2>/dev/null \
        | head -n1)

  LOG="$HOME/.steam/steam/logs/steamui_system.txt"

  if [[ ! -f "$VDF" ]]; then
    echo "[E] screenshots.vdf not found" >&2
    exit 1
  fi

  if [[ ! -f "$LOG" ]]; then
    echo "[E] steamui_system.txt log not found" >&2
    exit 1
  fi

  # Extract most recent Moonlight AppID
  MOONID=$(grep -E '"[0-9]+"\s*"Moonlight"' "$VDF" \
            | tail -n1 \
            | sed -E 's/.*"([0-9]+)".*"Moonlight".*/\1/')

  if [[ -z "$MOONID" ]]; then
    echo "[E] Could not find any Moonlight appid in $VDF" >&2
    exit 1
  fi

  echo "→ Latest Moonlight AppID = $MOONID"

  # Find last framerate line while that AppID was active
  FPS_LINE=$(awk -v GID="$MOONID" '
    /Settings profile change: game:/ { active = ($0 ~ "Settings profile change: game: " GID) }
    active && /CGamescopeController: set app target framerate:/ { last = $0 }
    END { print last }
  ' "$LOG")

  if [[ -z "$FPS_LINE" ]]; then
    echo "[E] No framerate entries found for appid $MOONID in $LOG" >&2
    FPS="$DISPLAY_FPS"
  else
    echo "→ Log line: $FPS_LINE"
    FPS="${FPS_LINE##*: }"
    echo "→ Parsed FPS from log = $FPS"
  fi
fi

# 4) Update Moonlight.conf
CONF="$HOME/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"
if [[ -f "$CONF" ]]; then
  sed -i "s|^fps=.*|fps=$FPS|" "$CONF"
  echo "→ Wrote fps=$FPS into $(basename "$CONF")"
else
  echo "[E] Moonlight.conf not found at $CONF" >&2
  exit 1
fi

# 5) Launch Moonlight
echo "Launching Moonlight…"
exec flatpak run com.moonlight_stream.Moonlight "$@"
