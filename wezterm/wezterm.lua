local wezterm = require("wezterm")
local config = require("config")
require("events")
-- Add this line to bypass the Wayland Explicit Sync crash
config.enable_wayland = false
-- require("events.update-status")
-- Apply color scheme based on the WEZTERM_THEME environment variable
local themes = {
	nord = "Nord (Gogh)",
	onedark = "One Dark (Gogh)",
}
local success, stdout, stderr = wezterm.run_child_process({ os.getenv("SHELL"), "-c", "printenv WEZTERM_THEME" })
local selected_theme = stdout:gsub("%s+", "") -- Remove all whitespace characters including newline
config.color_scheme = themes[selected_theme]

return config
