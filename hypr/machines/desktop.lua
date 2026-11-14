-- This is the archinstall of 07/06/2026
local mods = require("modules.var")

-- WORKSPACE RULES --

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-6",
    default = true,
    persistent = true
})
hl.workspace_rule({
    workspace = "2",
    monitor = "DP-4",
    default = true,
    persistent = true
})
hl.workspace_rule({
    workspace = "3",
    monitor = "DP-6"
})
hl.workspace_rule({
    workspace = "4",
    monitor = "DP-4"
})
hl.workspace_rule({
    workspace = "5",
    monitor = "HDMI-A-2",
    default = true,
    persistent = true
})
hl.workspace_rule({
    workspace = "6",
    monitor = "HDMI-A-2"
})
-- hl.workspace_rule({ -- don't think we need a 6th workspace allocated as default
--     workspace = "6",
--     monitor = "HDMI-A-2",

-- })
hl.workspace_rule({
    workspace = "name:gaming",
    monitor = "DP-4",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    no_rounding = true,
    layout = "monocle"
})

-- WINDOW RULES --

hl.window_rule({
    match = {
        workspace = "3"
    },
    float = true,
    size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
    opacity = 0.8,
    border_color = "rgb(FF00BF)"
})

hl.window_rule({
    match = {
        workspace = "4"
    },
    float = true,
    size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
    opacity = 0.8,
    border_color = "rgb(FF7700)"
})

hl.window_rule({
    match = {
        workspace = "6"
    },
    float = true,
    size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
    opacity = 0.8,
    border_color = "rgb(0077FF)"
})

hl.window_rule({
    match = {
        title = ".*Discord.*"
    },
    workspace = "6",
    size = {1200, 820},
    float = true,
    move = {15, 50}
})
hl.window_rule({
    match = {
        title = ".*Spotify.*"
    },
    workspace = "4",
    size = {1500, 900},
    float = true,
    move = {10, 50}
})

hl.window_rule({
    match = {
        class = "chromium"
    },
    workspace = "3",
    float = false
})

hl.window_rule({
    match = {
        class = "steam_app_3548580"
    },
    workspace = "5",
    fullscreen = true
})

hl.window_rule({
    match = {
        class = "hyprland-share-picker"
    },
    border_color = "rgb(0000FF)",
    workspace = "1"
})
hl.window_rule({
    match = {
        class = "com.obsproject.Studio"
    },
    border_color = "rgb(0000FF)",
    workspace = "1"
})

-- making flameshot work across multiple screens
hl.window_rule({
    name = "flameshot-multi-display-fix",
    match = {
        title = ".*flameshot.*"
    },
    float = true,
    pin = true,
    no_initial_focus = true,
    move = {0, 0},
    opacity = 1,
    -- size = {1920 * 2 + 1440, 1080},
    size = {"(monitor_w)", "(monitor_h)"},
    rounding = 0,
    border_size = 0,
    animation = fad
    -- workspace = "1"
})

-- force the rider terminal on a specific workspace
hl.window_rule({
    name = "rider-terminal-workspace",
    match = {
        initial_title = "Run",
        initial_class = "jetbrains-rider"
    },
    workspace = "2"
})

-- OTHER THINGS --

hl.bind(mods.mainMod .. " + CTRL + period", hl.dsp.exec_cmd("code ~/Documents/Code/Articles/"))

hl.on("hyprland.start", function()
    hl.exec_cmd("steam -silent")
end)
