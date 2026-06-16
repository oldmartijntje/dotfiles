-- This is the archinstall of 07/06/2026
local mods = require("modules.var")

hl.monitor({
    output   = "DP-4",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})
hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1440x900@60",
    position = "1920x0",
    scale    = "1",
})
hl.monitor({
    output   = "DP-6",
    mode     = "1920x1080@144",
    position = "-1920x0",
    scale    = "1",
})

hl.workspace_rule({ 
    workspace = "1",
    monitor = "DP-4",
    default = true
})

hl.workspace_rule({ 
    workspace = "2",
    monitor = "HDMI-A-2",
    default = true
})

hl.workspace_rule({ 
    workspace = "3",
    monitor = "DP-6",
    default = true
})

hl.workspace_rule({ 
    workspace = "name:gaming",
    monitor = "DP-4",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    no_rounding = true,
    layout = "monocle"
})

hl.bind(mods.mainMod .. " + CTRL + period", hl.dsp.exec_cmd("code ~/Documents/Code/Articles/"))

hl.window_rule({
  match = { title = ".*Discord.*" },
  border_color = "rgb(0000FF)",
  workspace = "2"
})
hl.window_rule({
  match = { title = ".*Spotify.*" },
  workspace = "2"
})

-- making flameshot work across multiple screens
hl.window_rule({
    name = "flameshot-multi-display-fix",
    match = { title = ".*flameshot.*" },
    float = true,
    pin = true,
    no_initial_focus = true,
    move = {-1920, 0},
    size = {1920 * 2 + 1440, 1080},
    rounding = 0,
    border_size = 0,
    animation = fad,
    workspace = "1"
})

hl.on("hyprland.start", function () 
  hl.exec_cmd("steam -silent")
end)