#!/usr/bin/env bash
# ~/.config/matugen/scripts/reload-hyprpaper.sh
#
# Called by matugen's post_hook for the [templates.hyprland] entry, with
# the new wallpaper path as $1 (matugen substitutes {{image}}).
#
# hyprpaper has no "set wallpaper" subcommand the way swww does — you load
# the image into memory, then assign it per-monitor. This script does both
# and clears the previous wallpaper from memory so it doesn't pile up.

set -euo pipefail

WALLPAPER="${1:-}"

# Expand ~ if matugen passes it literally
WALLPAPER="${WALLPAPER/#\~/$HOME}"

if ! pgrep -x hyprpaper >/dev/null; then
    hyprpaper &
    sleep 0.5
fi

# hyprctl hyprpaper preload "$WALLPAPER"

# Apply to every connected monitor (covers single 1900x1200 display setups
# and multi-monitor setups alike, without hardcoding a monitor name)
for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER,"
done

# Unload anything that's no longer in use to free memory
# hyprctl hyprpaper unload unused
