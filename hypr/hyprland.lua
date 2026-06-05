require("modules.binds")
require("modules.env")
require("modules.monitors")
require("modules.autostart")
require("modules.perms")
require("modules.input")
require("modules.design")

local machine = os.getenv("XDG_SESSION_OPT") or "laptop-eridani"
pcall(require, "machines." .. machine)