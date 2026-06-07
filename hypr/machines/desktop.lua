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

hl.bind(mods.mainMod .. " + CTRL + C", hl.dsp.exec_cmd("code ~/Documents/Code/Articles/"))