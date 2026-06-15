------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor({
--     output   = "eDP-1",
--     mode     = "1920x1080@144",
--     position = "0x0",
--     scale    = "1",
-- })

hl.workspace_rule({ 
    workspace = "0",
    monitor = "DP-4",
    default = true,
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    no_rounding = true,
    layout = "monocle"
})

hl.window_rule({
    name = "steam-big-picture",
    match = { class = "steam", title = "Steam Big Picture Mode" },
    workspace = "0",
})

hl.window_rule({
    name = "steam-games",
    match = { class = "steam_app_.*" },
    workspace = "0",
    fullscreen = true,
    no_anim = true,
    keep_aspect_ratio = true,  -- Force aspect ratio
    immediate = true,          -- Allow tearing for smoother fullscreen
})