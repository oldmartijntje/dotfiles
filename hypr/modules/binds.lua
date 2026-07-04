local mods = require("modules.var")

---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mods.mainMod .. " + Q", hl.dsp.exec_cmd(mods.terminal))
local closeWindowBind = hl.bind(mods.mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mods.mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mods.mainMod .. " + E", hl.dsp.exec_cmd(mods.fileManager))
hl.bind(mods.mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mods.mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mods.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("rofi -show combi -modes combi -combi-modes \"drun,run\""))
hl.bind(mods.mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mods.mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind("Print", hl.dsp.exec_cmd("grim - | flameshot gui"))

-- Move focus with mainMod + arrow keys
hl.bind(mods.mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mods.mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mods.mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mods.mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mods.mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mods.mainMod .. " + period", hl.dsp.exec_cmd("code"))
hl.bind(mods.mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("code ~/.config/"))

hl.bind(mods.mainMod .. " + D", hl.dsp.exec_cmd(mods.terminal .. " sudo lazydocker"))
hl.bind(mods.mainMod .. " + G", hl.dsp.exec_cmd(mods.terminal .. " lazygit"))
hl.bind(mods.mainMod .. " + O", hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian"))
hl.bind(mods.mainMod .. " + Z", hl.dsp.exec_cmd("flatpak run app.zen_browser.zen"))

hl.bind(mods.mainMod .. " + V", hl.dsp.exec_cmd("rofi -modi clipboard:~/.config/bash-scripts/cliphist-rofi-img.bash -show clipboard -theme-str 'element-icon { size: 32px; }'"))

hl.bind("ALT + TAB", hl.dsp.exec_cmd("rofi -show window"))
hl.bind("CTRL + ALT + TAB", hl.dsp.exec_cmd("rofi -show combi -modes combi -combi-modes \"window,drun\""))
hl.bind(mods.mainMod .. " + TAB", hl.dsp.exec_cmd("~/.config/bash-scripts/rofi_workspaces.sh"))


-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mods.mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mods.mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mods.mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mods.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mods.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mods.mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mods.mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mods.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })