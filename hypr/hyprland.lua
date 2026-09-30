require("modules.binds")
require("modules.env")
require("modules.monitors")
require("modules.autostart")
require("modules.perms")
require("modules.input")
require("modules.design")

require("generated.monitor")

local machine = os.getenv("XDG_SESSION_OPT") or "archlinux"
if machine == "archlinux" then
    require("machines.default")
else
    pcall(require, "machines." .. machine)
end