# Matugen setup

Generates a Material You palette from the current wallpaper and writes it into every app's colors.

## What's in here

```
matugen/
  config.toml                 → template list + post hooks
  templates/
    hyprland-colors.lua       → ~/.config/hypr/colors.lua (border colors, wallpaper path)
    hyprlock-colors.conf      → ~/.config/hypr/colors-hyprlock.conf
    kitty-theme.conf          → ~/.config/kitty/themes/Matugen.conf
    gtk-colors.css            → ~/.config/gtk-4.0/colors.css (libadwaita named colors)
    gtk3-colors.css           → ~/.config/gtk-3.0/colors.css (same + GTK 3 legacy names, for adw-gtk3)
    quickshell-colors.qml     → ~/.config/quickshell/lanicOS/colors/Colors.qml
    palette.css               → ~/.config/matugen/current_palette.css
  scripts/
    reload-hyprpaper.sh       → sets the new wallpaper on every monitor (needs jq)
    reload-kitty.sh           → applies the kitty theme offline (copy + SIGUSR1, no session loss)
```

## Generating colors

Use the theme script, it relinks the wallpaper and runs matugen for you:

```bash
~/.config/theming-scripts/matugen.sh [dark|light] [/path/to/wallpaper]
```

It runs `matugen image "$WALLPAPER" -m "$MODE" --source-color-index 0`. The index picks the most dominant color without prompting, so it also works without a terminal (keybinds, quickshell).

To regenerate a single template without triggering the other hooks (e.g. `nautilus -q`), use a temporary config holding only that `[templates.*]` entry:

```bash
matugen -c /tmp/only-gtk3.toml image ~/.config/hypr/CURRENT_WALLPAPER -m dark --source-color-index 0
```