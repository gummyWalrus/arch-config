---------------------
---- KEYBINDINGS ----
---------------------
--- Toggle fullscreen

--- Cycling workspace ---
hl.bind(mainMod .. " + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ workspace = "e+1" }))

--- Taking screenshots
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" -  | wl-copy'))

--- Clipboard history
hl.bind(mainMod .. "+ V", hl.dsp.global("quickshell:clipboard_history"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
