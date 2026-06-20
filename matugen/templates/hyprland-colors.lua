-- {#- ~/.config/matugen/templates/hyprland-colors.lua -#}
-- {#- Generates ~/.config/hypr/colors.lua — required from hyprland.lua -#}
-- {#- This is a Lua MODULE: it returns a table, it does not call hl.config -#}
-- {#- itself. hyprland.lua decides what to do with the values.            -#}

return {
    wallpaper = "{{image}}",

    primary = "rgb({{colors.primary.default.hex_stripped}})",
    on_primary = "rgb({{colors.on_primary.default.hex_stripped}})",
    primary_container = "rgb({{colors.primary_container.default.hex_stripped}})",
    on_primary_container = "rgb({{colors.on_primary_container.default.hex_stripped}})",

    secondary = "rgb({{colors.secondary.default.hex_stripped}})",
    on_secondary = "rgb({{colors.on_secondary.default.hex_stripped}})",

    tertiary = "rgb({{colors.tertiary.default.hex_stripped}})",
    on_tertiary = "rgb({{colors.on_tertiary.default.hex_stripped}})",

    surface = "rgb({{colors.surface.default.hex_stripped}})",
    on_surface = "rgb({{colors.on_surface.default.hex_stripped}})",
    surface_container = "rgb({{colors.surface_container.default.hex_stripped}})",
    surface_container_high = "rgb({{colors.surface_container_high.default.hex_stripped}})",

    outline = "rgb({{colors.outline.default.hex_stripped}})",
    error = "rgb({{colors.error.default.hex_stripped}})",
    shadow = "rgb({{colors.shadow.default.hex_stripped}})",

    -- Convenience aliases, same role as the old $active_border_color
    active_border_color = "rgb({{colors.primary.default.hex_stripped}})",
    inactive_border_color = "rgb({{colors.surface_container_high.default.hex_stripped}})",
}
