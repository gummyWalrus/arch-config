#!/usr/bin/env bash
#
# Flips GTK's color-scheme preference AND regenerates all matugen templates
# in the matching mode, so GTK apps and your Hyprland/Waybar/Wofi colors
# switch together. Run with no arguments to toggle, or pass "dark"/"light"
# to force a specific mode.


WALLPAPER="$HOME/.config/hypr/CURRENT_WALLPAPER"
STATE_FILE="$HOME/.cache/matugen/current-mode"
mkdir -p "$(dirname "$STATE_FILE")"



current_mode() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null \
            | grep -q "prefer-dark" && echo "dark" || echo "light"
    fi
}

link_new_wallpaper() {
    rm $WALLPAPER
    ln -s $NEW_WP $WALLPAPER
    echo "New wallpaper link created"

}

if [[ "${1:-}" == "dark" || "${1:-}" == "light" ]]; then
    MODE="$1"
else
    [[ "$(current_mode)" == "dark" ]] && MODE="light" || MODE="dark"
fi

if [[  -f "${2:-}"  ]]; then
    NEW_WP="$2"
    link_new_wallpaper
fi



echo "$MODE" > "$STATE_FILE"

matugen image "$WALLPAPER" -m "$MODE"

echo "Theme switched to $MODE"