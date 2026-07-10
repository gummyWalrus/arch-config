# Matugen + Hyprland setup

Generated for: Hyprland, hyprpaper, Waybar, Wofi, and (best-effort) SDDM.

## What's in here

```
matugen/
  config.toml                      → ~/.config/matugen/config.toml
  templates/
    hyprland-colors.conf           → defines $primary, $surface, etc. for hyprland.conf
    hyprlock-colors.conf           → same, namespaced for hyprlock.conf
    waybar-colors.css              → @define-color rules for Waybar
    wofi-colors.css                → @define-color rules for Wofi
    sddm-colors.conf               → plain key=value staging file (see caveat below)
  scripts/
    reload-hyprpaper.sh            → loads new wallpaper into hyprpaper on every monitor
    sync-sddm.sh                   → copies staged colors into an installed SDDM theme

hypr/
  hyprland.conf.snippet            → source line, monitor line, border/shadow colors, autostart
  hyprpaper.conf                   → minimal startup config for hyprpaper
  hyprlock.conf.snippet            → source line + a colored lock screen
```

These are **snippets to merge into your existing configs**, not drop-in
replacements — copy the relevant blocks into your real `hyprland.conf`,
`hyprlock.conf`, etc.

## Install

```bash
mkdir -p ~/.config/matugen/{templates,scripts}
cp matugen/config.toml ~/.config/matugen/config.toml
cp matugen/templates/* ~/.config/matugen/templates/
cp matugen/scripts/* ~/.config/matugen/scripts/
chmod +x ~/.config/matugen/scripts/*.sh

mkdir -p ~/.config/hypr
cp hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
# merge hypr/hyprland.conf.snippet into ~/.config/hypr/hyprland.conf
# merge hypr/hyprlock.conf.snippet into ~/.config/hypr/hyprlock.conf
```

In `waybar/style.css` and `wofi/style.css`, add at the very top:
```css
@import "colors.css";
```

Pick a wallpaper and symlink it to a stable path so hyprpaper's startup
config always finds something:
```bash
ln -sf /path/to/your/wallpaper.jpg ~/.config/hypr/wallpaper_current
```

## Generating colors

```bash
matugen image ~/.config/hypr/wallpaper_current --mode dark
```

Use `--mode light` for a light scheme. This single command regenerates
Hyprland border colors, the hyprlock screen, Waybar, Wofi, and stages the
SDDM colors — then reloads hyprpaper, Waybar, and stages SDDM automatically
via the `post_hook` entries in `config.toml`.

To switch wallpaper and re-theme in one step, update the symlink first:
```bash
ln -sf /path/to/new-wallpaper.jpg ~/.config/hypr/wallpaper_current
matugen image ~/.config/hypr/wallpaper_current --mode dark
```

## About your 1900x1200 screen

That's not a standard panel resolution — most "1900-class" Hyprland setups
are actually 1920x1200 (16:10). Run `hyprctl monitors` after Hyprland is
running to see your output's real name and supported modes, then fix the
`monitor = ` line in `hyprland.conf.snippet` accordingly. If 1900x1200 is
genuinely correct (some odd panels and VMs report this), Hyprland will
still accept it as a custom mode as long as the driver reports it as
available — just don't assume it without checking.

## The SDDM caveat — read this before relying on it

Matugen does **not** have official SDDM support, unlike Hyprland, Waybar,
and Wofi. The reasons are structural, not a missing feature:

- SDDM starts before any user logs in and runs as its own user/root, so it
  can't read files in your `~/.config`.
- Its themes live under `/usr/share/sddm/themes/<name>/`, which your user
  account can't write to without `sudo`.
- There's no live reload — the login screen is rendered fresh each time
  SDDM starts, so "syncing" only ever prepares the *next* login screen, not
  the current session's lock screen (that's hyprlock's job, and it already
  has full Matugen support above).

What `sync-sddm.sh` does instead: it stages your latest colors as
`theme.conf.matugen` inside an installed theme directory, using a narrow
passwordless-sudo rule for that one `cp` command (instructions are in the
script's comments). This only works if your SDDM theme is actually built
to read an external color override file — most AUR themes like
`sddm-theme-sugar-candy` or `sddm-theme-corners` support this pattern, but
you'll need to check that theme's own docs for the exact variable names it
expects and wire `sddm-colors.conf`'s keys to match.

If you'd rather skip the complexity, just delete the `[templates.sddm]`
block from `config.toml` — Hyprland, Waybar, and Wofi will still re-theme
correctly without it.
