------------------
---- MONITORS ----
------------------

-- use `hyprctl clients` to find all windows, TIP: make the window you are looking for the only one floating.


-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor({
--     output   = "eDP-1",
--     mode     = "1920x1080@144",
--     position = "0x0",
--     scale    = "1",
-- })

hl.window_rule({
    name = "steam-big-picture",
    match = { class = "steam", title = "Steam Big Picture Mode" },
    workspace = "name:gaming",
})

hl.window_rule({
    name = "steam-games",
    match = { class = "steam_app_.*" },
    workspace = "name:gaming",
    fullscreen = true,
    no_anim = true,
    keep_aspect_ratio = true,  -- Force aspect ratio
    immediate = true,          -- Allow tearing for smoother fullscreen
})

-- force the rider terminal to not float (it does by default)
hl.window_rule({
    name = "rider-terminal",
    match = { initial_title = "Run", initial_class = "jetbrains-rider" },
    float = false
})