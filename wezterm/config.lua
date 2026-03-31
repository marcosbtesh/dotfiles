local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.font_size = 13.5
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.enable_tab_bar = true
config.window_padding = {
	left = 7,
	right = 7,
	top = 2,
	bottom = 0,
}
config.tab_max_width = 40
config.scrollback_lines = 10000
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 0.6,
	brightness = 0.6,
}

config.background = {
	{
		source = {
			File = wezterm.home_dir .. "/.config/wezterm/dark-desert.jpg",
		},
		hsb = {
			hue = 1.0,
			saturation = 1.02,
			brightness = 0.25,
		},
	},
	{
		source = {
			Color = "#000000",
		},
		width = "100%",
		height = "100%",
		opacity = 0.7,
	},
}
config.window_background_opacity = 0
config.macos_window_background_blur = 20
config.keys = {
	-- Prompt before closing the current tab
	{
		key = "w",
		mods = "CMD", -- Or 'CTRL' on Windows/Linux
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	-- Prompt before closing the current pane
	{
		key = "q",
		mods = "CMD", -- Or 'CTRL' on Windows/Linux
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{ key = "Enter", mods = "CTRL", action = wezterm.action({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
}
-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
}
-- Tab bar colors (Tokyo Night palette, matching the status bar)
config.colors = {
	tab_bar = {
		background = "#1f2335",
		active_tab = {
			bg_color = "#7aa2f7",
			fg_color = "#15161e",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#24283b",
			fg_color = "#565f89",
		},
		inactive_tab_hover = {
			bg_color = "#3d59a1",
			fg_color = "#c0caf5",
		},
		new_tab = {
			bg_color = "#1f2335",
			fg_color = "#565f89",
		},
		new_tab_hover = {
			bg_color = "#3d59a1",
			fg_color = "#c0caf5",
		},
	},
}

return config
