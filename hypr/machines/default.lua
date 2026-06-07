-- for if you forget to select. 
local mods = require("modules.var")

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

hl.exec_cmd("rofi -theme-str '#window { fullscreen: false; }' -e \"WARNING:\nYou haven't selected a XDG_SESSION_OPT in your ~/.config/hypr/modules/env.lua\nThis will probalby have catastrophic implications\"")