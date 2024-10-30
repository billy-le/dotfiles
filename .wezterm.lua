local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Tokyo Night (Gogh)"
config.font = wezterm.font("Reddit Mono")
config.font_size = 16

-- Tab bar config
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- Hide title bar but allow resizing
config.window_decorations = "RESIZE"

-- Preserve Battery Life
config.front_end = "WebGpu"
config.webgpu_power_preference = "LowPower"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 12

return config
