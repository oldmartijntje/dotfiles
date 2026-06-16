-- This is the archinstall of 28/05/2026 (probook laptop)
local mods = require("modules.var")

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

hl.workspace_rule({ 
    workspace = "1",
    monitor = "eDP-1",
    default = true
})

hl.workspace_rule({ 
    workspace = "name:gaming",
    monitor = "eDP-1",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    no_rounding = true,
    layout = "monocle"
})

hl.bind(mods.mainMod .. " + CTRL + period", hl.dsp.exec_cmd("code ~/Documents/Articles/"))

hl.window_rule({
    name = "flameshot-multi-display-fix",
    match = { title = ".*flameshot.*" },
    float = true,
    pin = true,
    no_initial_focus = true,
    move = {-0, 0},
    size = {1920, 1080},
    rounding = 0,
    border_size = 0,
    animation = fad,
    workspace = "1"
})