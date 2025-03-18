-- Pull in WezTerm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 18

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.colors = theme.colors()
config.window_frame = theme.window_frame()

-- and finally, return the configuration to wezterm
return config
