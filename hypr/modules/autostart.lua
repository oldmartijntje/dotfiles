local mods = require("modules.var")

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
  hl.exec_cmd(mods.terminal)
  hl.exec_cmd("nm-applet & hyprsunset")
  hl.exec_cmd("waybar & hyprpaper & flatpak run app.zen_browser.zen")
end)