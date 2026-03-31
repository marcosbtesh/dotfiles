local wezterm = require("wezterm")

local process_icons = {
	["nvim"] = "",
	["vim"] = "",
	["bash"] = "",
	["zsh"] = "",
	["fish"] = "",
	["tmux"] = "",
	["ssh"] = "󰣀",
	["git"] = "",
	["lazygit"] = "",
	["node"] = "",
	["python3"] = "",
	["python"] = "",
	["cargo"] = "",
	["go"] = "",
	["docker"] = "",
	["kubectl"] = "󱃾",
	["top"] = "",
	["htop"] = "",
	["man"] = "",
}

local function get_process_icon(pane)
	local process_name = pane.foreground_process_name
	if process_name and #process_name > 0 then
		local base = process_name:match("([^/]+)$") or process_name
		return process_icons[base] or ""
	end
	return ""
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local icon = get_process_icon(pane)

	local title = tab.tab_title
	if not title or #title == 0 then
		title = pane.title
	end
	-- Strip trailing shell prompt noise (e.g. "zsh: ~/some/path")
	title = title:match("^%w+:%s*(.+)") or title
	-- Truncate
	local max_title = max_width - 6
	if #title > max_title then
		title = title:sub(1, max_title - 1) .. "…"
	end

	local display = icon ~= "" and (icon .. "  " .. title) or title
	local index = tostring(tab.tab_index + 1)

	if tab.is_active then
		return {
			{ Attribute = { Intensity = "Bold" } },
			{ Text = " " .. index .. ": " .. display .. " " },
		}
	end
	return {
		{ Attribute = { Intensity = "Half" } },
		{ Text = " " .. index .. ": " .. display .. " " },
	}
end)
