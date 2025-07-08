#!/usr/bin/env bash

set -euo pipefail

# --- Clear previous log file ----------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: > "$SCRIPT_DIR/wrapper.log"

# --- 1) Static variables & checks -------------------------------------------
HOME_DIR="$HOME"

# Moonlight config path
CONF="$HOME_DIR/.var/app/com.moonlight_stream.Moonlight/config/Moonlight Game Streaming Project/Moonlight.conf"
[[ -f "$CONF" ]] || { echo "[ERROR] Config not found at $CONF" >&2; exit 1; }

# SteamUI log path (native or Flatpak)
LOG="$HOME_DIR/.steam/steam/logs/steamui_system.txt"
if [[ ! -f "$LOG" ]]; then
  LOG="$HOME_DIR/.var/app/com.valvesoftware.Steam/data/Steam/logs/steamui_system.txt"
fi
[[ -f "$LOG" ]] || { echo "[ERROR] SteamUI log not found at $LOG" >&2; exit 1; }

# --- 2) Log file creation ----------------------------------------------------
LOGFILE="$SCRIPT_DIR/wrapper.log"

wlog(){
  local ts="[$(date +'%Y-%m-%d %H:%M:%S')]"
  echo "${ts} $*" >&2
  echo "${ts} $*" >>"$LOGFILE"
}

wlog "CHECK: HOME_DIR = $HOME_DIR"
wlog "FOUND: CONF = $CONF"
wlog "FOUND: STEAMUI_LOG = $LOG"

# --- 3) Detect display FPS -------------------------------------------------
RATE=$(xrandr | grep -Po '\d+\.\d+(?=\*)' | head -n1)
DISPLAY_FPS=$(printf '%.0f' "${RATE:-0}")
wlog "CHECK: DISPLAY_FPS = ${DISPLAY_FPS} fps"

# --- 4) Mode decision -------------------------------------------------------
if [[ "${SteamDeck:-0}" == "1" ]]; then
  MODE=gaming
else
  MODE=desktop
fi
wlog "STATE: MODE = ${MODE^^}"

# --- 5) Desktop mode --------------------------------------------------------
if [[ "$MODE" == "desktop" ]]; then
  wlog "DESKTOP: patching fps → $DISPLAY_FPS"
  sed -i "s|^fps=.*|fps=$DISPLAY_FPS|" "$CONF"
  wlog "DESKTOP: launching Moonlight"
  exec flatpak run com.moonlight_stream.Moonlight "$@"
fi

# --- 6) Gaming mode functions ----------------------------------------------
seed_fps(){
  local last
  last=$(
    grep 'CGamescopeController: set app target framerate:' "$LOG" \
      | tail -n1 \
      | sed -E 's/.*: //' \
      | tr -d '\r' \
      | sed -E 's/[[:space:]]+$//'
  )
  # if nothing found, fall back to display FPS
  printf '%s' "${last:-$DISPLAY_FPS}"
}

patch_conf(){
  wlog "PATCH: fps=$1"
  sed -i "s|^fps=.*|fps=$1|" "$CONF"
}

kill_moonlight(){
  wlog "KILL: Tearing down Moonlight for planned restart"
  flatpak kill com.moonlight_stream.Moonlight &>/dev/null || true
}

launch_moonlight(){
  local ctxt="$1"; shift
  wlog "LAUNCH ($ctxt): starting Moonlight (fps=$CURRENT_FPS)"
  flatpak run com.moonlight_stream.Moonlight "$@" &
}

monitor_fps_changes(){
  tail -n0 -F "$LOG" | while read -r line; do
    if [[ "$line" =~ CGamescopeController:\ set\ app\ target\ framerate:\ ([0-9]+) ]]; then
      echo "${BASH_REMATCH[1]}"
      wlog "EVENT: SteamUI FPS cap → ${BASH_REMATCH[1]}"
    fi
  done
}

start_zombie_killer(){
  (
    while true; do
      sleep 5
      # If no bwrap sandboxes are alive, declare zombie state
      if ! pgrep -x bwrap &>/dev/null; then
        wlog "EVENT: Entered zombie state..."
        wlog "CLEANUP: killing Moonlight flatpak"
        pkill -f 'flatpak run com.moonlight_stream.Moonlight' &>/dev/null || true
        wlog "CLEANUP: killing other Moonlight processes"
        pkill -f moonlight                             &>/dev/null || true
      fi
    done
  ) &
  PERIODIC_DIAG_PID=$!
  wlog "EVENT: Started anti-zombification protocol (PID=$PERIODIC_DIAG_PID)"
}

# --- 7) Gaming mode orchestration -------------------------------------------
CURRENT_FPS=$(seed_fps)
wlog "STATE: startup FPS = $CURRENT_FPS"

patch_conf "$CURRENT_FPS"
launch_moonlight initial "$@"
start_zombie_killer

monitor_fps_changes | while read -r CAP; do
  if [[ "$CAP" != "$CURRENT_FPS" ]]; then
    wlog "RESTART: $CURRENT_FPS → $CAP"
    CURRENT_FPS="$CAP"
    kill_moonlight
    patch_conf "$CURRENT_FPS"
    launch_moonlight restart "$@"
  else
    wlog "IGNORE: duplicate cap = $CAP"
  fi
 done
