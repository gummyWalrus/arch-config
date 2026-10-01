#!/usr/bin/env bash
# ~/.config/matugen/scripts/reload-kitty.sh
#
# Called by matugen's post_hook for the [templates.kitty] entry.
#
# Does what `kitty +kitten themes --reload-in=all Matugen` did, but offline:
# the themes kitten refreshes its theme-repo cache from GitHub before doing
# anything, so it fails without internet. Copying the generated theme into
# current-theme.conf (included by kitty.conf) and sending SIGUSR1 makes every
# running kitty reload its config — no network, no remote control needed.

set -euo pipefail

cp ~/.config/kitty/themes/Matugen.conf ~/.config/kitty/current-theme.conf

# SIGUSR1 is kitty's "reload config" signal, not a kill: windows, tabs and
# running programs stay as they are. No kitty running is fine.
pkill -USR1 -x kitty || true
