-- for if you forget to select. 
local mods = require("modules.var")

hl.exec_cmd("rofi -theme-str '#window { fullscreen: false; }' -e \"WARNING:\nYou haven't selected a XDG_SESSION_OPT in your ~/.config/hypr/modules/env.lua\nThis will probalby have catastrophic implications\"")