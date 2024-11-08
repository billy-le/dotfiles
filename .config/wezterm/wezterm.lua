local wezterm = require("wezterm")
local mux = wezterm.mux

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- config.default_prog = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "default" }
config.color_scheme = "Tokyo Night (Gogh)"
config.font = wezterm.font("Reddit Mono")
config.font_size = 16

-- Tab bar config
config.enable_tab_bar = false

-- Hide title bar but allow resizing
config.window_decorations = "RESIZE"

-- Preserve Battery Life
config.front_end = "WebGpu"
config.webgpu_power_preference = "LowPower"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 12
config.window_padding = {
	left = 5,
	right = 5,
	top = 0,
	bottom = 0,
}
config.animation_fps = 120
config.max_fps = 120
config.automatically_reload_config = true

return config
