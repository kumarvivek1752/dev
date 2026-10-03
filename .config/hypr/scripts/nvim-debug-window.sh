#!/usr/bin/env bash
# Opens a small floating kitty window running a clean Neovim, for debugging.
# Prints the EDITOR pid on stdout (nvim-dap attaches to it).
#
#   nvim-debug-window.sh [path-to-nvim]
#
# Why the dispatchers instead of windowrules: on Hyprland 0.56 a new kitty
# window comes up with fullscreen=1 (that value means *maximized*), and while
# any non-zero fullscreen state is set, `size`/`move` windowrules and
# resizewindowpixel are refused with "Window is fullscreen". So we clear the
# state first, then float/resize/move by address. Verified on eDP-1.
#
# Why --listen: `nvim` in a terminal is two processes (TUI + an `nvim --embed`
# child that is the actual editor). Breakpoints must go on the child, so we ask
# Neovim itself for getpid() over the socket rather than guessing with pgrep.

set -uo pipefail

NVIM_BIN="${1:-$HOME/work/oss/neovim/build-debug/bin/nvim}"
CLASS="nvim-debug"
SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nvim-debug.sock"
WIDTH=1024
HEIGHT=700

[ -x "$NVIM_BIN" ] || { echo "not executable: $NVIM_BIN" >&2; exit 1; }

# One debug window at a time. Match on the cmdline but only kill real kitty
# processes: a bare `pkill -f "kitty --class ..."` also matches any shell whose
# own command line contains that string, including the one running this script.
for p in $(pgrep -f "kitty --class $CLASS" 2>/dev/null); do
  [ "$(ps -o comm= -p "$p" 2>/dev/null)" = "kitty" ] && kill -9 "$p" 2>/dev/null
done
# Also any nvim still holding our socket. If a debug session is killed abruptly
# the debuggee is left ptrace-stopped (ps STAT "t"), where a plain TERM never
# arrives - and it then shows up in dap's process picker and refuses attach.
# SIGKILL is the only thing that reaches it.
for p in $(pgrep -f -- "--listen $SOCK" 2>/dev/null); do
  [ "$(ps -o comm= -p "$p" 2>/dev/null)" = "nvim" ] && kill -9 "$p" 2>/dev/null
done
rm -f "$SOCK"

kitty --class "$CLASS" -e "$NVIM_BIN" --clean --listen "$SOCK" >/dev/null 2>&1 &

# Wait for the editor to be up (socket appears).
for _ in $(seq 1 100); do
  [ -S "$SOCK" ] && break
  sleep 0.1
done
[ -S "$SOCK" ] || { echo "nvim did not start (no $SOCK)" >&2; exit 1; }

# Place the window: centred, WIDTHxHEIGHT, floating.
if command -v hyprctl >/dev/null 2>&1; then
  for _ in $(seq 1 50); do
    ADDR=$(hyprctl clients -j | jq -r --arg c "$CLASS" \
      '.[] | select(.class==$c) | .address' | head -1)
    [ -n "$ADDR" ] && break
    sleep 0.1
  done
  if [ -n "${ADDR:-}" ]; then
    read -r MW MH < <(hyprctl monitors -j | jq -r \
      '.[0] | "\((.width/.scale)|floor) \((.height/.scale)|floor)"')
    X=$(( (MW - WIDTH) / 2 ))
    Y=$(( (MH - HEIGHT) / 2 ))
    hyprctl dispatch focuswindow "address:$ADDR"              >/dev/null
    hyprctl dispatch fullscreenstate 0 0                       >/dev/null
    hyprctl dispatch setfloating "address:$ADDR"               >/dev/null
    hyprctl dispatch resizewindowpixel "exact $WIDTH $HEIGHT,address:$ADDR" >/dev/null
    hyprctl dispatch movewindowpixel  "exact $X $Y,address:$ADDR"           >/dev/null
  fi
fi

# The pid of the --embed child, straight from Neovim.
nvim --server "$SOCK" --remote-expr 'getpid()'
