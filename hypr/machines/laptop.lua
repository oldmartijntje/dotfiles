-- This is the archinstall of 28/05/2026 (probook laptop)
local mods = require("modules.var")

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

hl.bind(mods.mainMod .. " + CTRL + C", hl.dsp.exec_cmd("code ~/Documents/Articles/"))