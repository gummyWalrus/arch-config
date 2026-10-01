#!/usr/bin/env bash
# ~/.config/matugen/scripts/sync-sddm.sh
#
# SDDM runs as root, before any user session starts, and reads its theme
# from /usr/share/sddm/themes/<theme>/theme.conf — a system path your user
# can't write to. There is no "live" way to theme SDDM the way Waybar or
# file in sync with your latest palette, which is what this script does.
#
# Prerequisites (one-time):
#   1. Install an SDDM theme that supports a theme.conf color override,
#      e.g. sddm-theme-sugar-candy or sddm-theme-corners (AUR).
#   2. Set SDDM_THEME below to that theme's directory name.
#   3. Add a sudoers rule so this one cp command doesn't prompt every time:
#        echo "yourusername ALL=(ALL) NOPASSWD: /usr/bin/cp /home/yourusername/.cache/matugen/sddm-colors.conf /usr/share/sddm/themes/*/theme.conf.matugen" \
#          | sudo tee /etc/sudoers.d/matugen-sddm
#
# This script does NOT change the SDDM login background mid-session — it
# stages the new colors so the NEXT login screen reflects your latest
# wallpaper. That's the practical ceiling for SDDM theming.

set -euo pipefail

SDDM_THEME="sugar-candy"   # <-- change to your installed theme's folder name
SRC="$HOME/.cache/matugen/sddm-colors.conf"
DEST_DIR="/usr/share/sddm/themes/${SDDM_THEME}"
DEST="${DEST_DIR}/theme.conf.matugen"

if [[ ! -d "$DEST_DIR" ]]; then
    echo "sync-sddm.sh: $DEST_DIR not found — check SDDM_THEME, or skip SDDM sync" >&2
    exit 0
fi

sudo -n cp "$SRC" "$DEST" 2>/dev/null || {
    echo "sync-sddm.sh: needs passwordless sudo for cp — see comments in this script" >&2
    exit 0
}

echo "sync-sddm.sh: staged new colors for next login screen"
