local wezterm = require("wezterm")

-- CONFIGURATION
local REFRESH_RATE = 5 -- How often to update CPU/RAM (in seconds) to save battery
local HOST_ICON = ""
local CPU_ICON = ""
local RAM_ICON = ""
local DATE_ICON = ""
local BATTERY_ICON = ""

-- Helper: Process system info (cached to prevent lag)
local system_info_cache = { cpu = "0%", ram = "0%" }
local last_update_time = 0

local function get_system_resources()
  local now = os.time()
  if now - last_update_time < REFRESH_RATE then
    return system_info_cache
  end

  -- macOS specific commands for CPU/RAM
  -- Note: 'top' can be heavy, so we run it sparingly
  local success, stdout, _ = wezterm.run_child_process({
    "sh",
    "-c",
    "top -l 1 | grep -E '^CPU|^PhysMem'",
  })

  if success then
    -- Parse CPU: "CPU usage: 12.34% user, 5.67% sys..."
    local cpu_user = stdout:match("CPU usage: (%d+%.?%d*)%% user") or "0"
    local cpu_sys = stdout:match("(%d+%.?%d*)%% sys") or "0"
    local cpu_total = math.floor(tonumber(cpu_user) + tonumber(cpu_sys))

    -- Parse RAM: "PhysMem: 12G used (3G wired), 4G unused."
    local ram_used = stdout:match("PhysMem: (%d+[GM]) used") or "0M"

    system_info_cache = {
      cpu = cpu_total .. "%",
      ram = ram_used,
    }
    last_update_time = now
  end

  return system_info_cache
end

-- Helper: Get Battery Icon and Color
local function get_battery_info()
  local batt = wezterm.battery_info()[1]
  if not batt then
    return ""
  end

  local percentage = batt.state_of_charge * 100
  local icon = ""
  local color = "#98bb6c" -- Green (Nord)

  if percentage < 15 then
    icon = ""
    color = "#e46876" -- Red
  elseif percentage < 30 then
    icon = ""
    color = "#d27e99" -- Pink/Warn
  elseif percentage < 50 then
    icon = ""
  elseif percentage < 80 then
    icon = ""
  end

  if batt.state == "Charging" then
    icon = " " .. icon
  end

  return string.format("%.0f%% %s", percentage, icon), color
end

-- Helper: Create a Powerline Segment
local function segment(text, fg, bg)
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. text .. " " },
  }
end

-- EVENT LISTENER
wezterm.on("update-status", function(window, pane)
  -- 1. Grab System Info
  local sys = get_system_resources()
  local batt_text, batt_color = get_battery_info()
  local date_text = wezterm.strftime("%H:%M %a %d")

  -- 2. Define Colors (Nord / Hendrimi Style Palette)
  local colors = {
    bg = "#1f2335",    -- Darker background
    mode_bg = "#7aa2f7", -- Blue
    cpu_bg = "#3d59a1", -- Dark Blue
    ram_bg = "#414868", -- Grey-Blue
    date_bg = "#16161e", -- Blackish
    fg = "#c0caf5",    -- White-ish
  }

  -- 3. Determine Mode (Normal, Copy, Search)
  local key_table = window:active_key_table()
  local mode_text = "NORMAL"
  local mode_bg = colors.mode_bg

  if key_table then
    mode_text = key_table:upper()
    mode_bg = "#e0af68" -- Orange for special modes
  end

  -- 4. Build the Status Bar Elements
  local elements = {}

  -- Arrow Separator Helper
  local function arrow(prev_bg, next_bg)
    table.insert(elements, { Background = { Color = next_bg } })
    table.insert(elements, { Foreground = { Color = prev_bg } })
    table.insert(elements, { Text = "" })
  end

  -- Mode Segment
  table.insert(elements, { Background = { Color = mode_bg } })
  table.insert(elements, { Foreground = { Color = "#15161e" } })
  table.insert(elements, { Text = " " .. HOST_ICON .. " " .. mode_text .. " " })

  -- CPU Segment
  arrow(mode_bg, colors.cpu_bg)
  table.insert(elements, segment(CPU_ICON .. " " .. sys.cpu, colors.fg, colors.cpu_bg))

  -- RAM Segment
  arrow(colors.cpu_bg, colors.ram_bg)
  table.insert(elements, segment(RAM_ICON .. " " .. sys.ram, colors.fg, colors.ram_bg))

  -- Battery Segment (if exists)
  if batt_text ~= "" then
    arrow(colors.ram_bg, colors.bg) -- Use transparent/term bg for battery to stand out
    table.insert(elements, { Background = { Color = colors.bg } })
    table.insert(elements, { Foreground = { Color = batt_color } })
    table.insert(elements, { Text = " " .. batt_text .. " " })
    arrow(colors.bg, colors.date_bg)
  else
    arrow(colors.ram_bg, colors.date_bg)
  end

  -- Date Segment
  table.insert(elements, segment(DATE_ICON .. " " .. date_text, "#7aa2f7", colors.date_bg))

  -- Set the Status
  window:set_right_status(wezterm.format(elements))
end)
