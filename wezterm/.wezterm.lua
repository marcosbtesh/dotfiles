local wezterm = require("wezterm")

-- readably shorteners
local nf = wezterm.nerdfonts

-- Cache git results briefly to avoid running git on every frame
local GIT_CACHE = { path = "", when = 0, out = "" }
local function git_info(cwd)
  if not cwd or cwd == "" then return "" end
  local now = wezterm.time.now()
  if GIT_CACHE.path == cwd and (now - GIT_CACHE.when) < 1.0 then
    return GIT_CACHE.out
  end

  local cmd = string.format(
    "cd %q && git rev-parse --is-inside-work-tree >/dev/null 2>&1 && " ..
    "git status --porcelain=2 -b",
    cwd
  )
  local ok, out, _ = wezterm.run_child_process({ "bash", "-lc", cmd })
  if not ok or out == "" then
    GIT_CACHE = { path = cwd, when = now, out = "" }
    return ""
  end

  local branch, ahead, behind = "", 0, 0
  local staged, changed, untracked = 0, 0, 0

  for i, line in ipairs(wezterm.split_by_newlines(out)) do
    if i == 1 then
      -- Example: ## main...origin/main [ahead 1, behind 2]
      branch = line:match("^## ([^%.%s]+)") or line:match("^## (.+)$") or ""
      ahead = tonumber(line:match("ahead (%d+)")) or 0
      behind = tonumber(line:match("behind (%d+)")) or 0
    else
      -- Porcelain v2: '1 ' or '2 ' entries = tracked changes; '?' = untracked
      if line:sub(1,1) == "?" then
        untracked = untracked + 1
      elseif line:sub(1,1) == "1" or line:sub(1,1) == "2" then
        local xy = line:sub(3,4)
        if xy:sub(1,1) ~= "." then staged = staged + 1 end
        if xy:sub(2,2) ~= "." then changed = changed + 1 end
      end
    end
  end

  local parts = {}
  if branch ~= "" then
    table.insert(parts, nf.fa_code_fork .. " " .. branch)
  end
  if ahead > 0 then table.insert(parts, "↑" .. ahead) end
  if behind > 0 then table.insert(parts, "↓" .. behind) end
  if staged > 0 then table.insert(parts, "●" .. staged) end
  if changed > 0 then table.insert(parts, "✚" .. changed) end
  if untracked > 0 then table.insert(parts, "…".. untracked) end

  local txt = table.concat(parts, " ")
  GIT_CACHE = { path = cwd, when = now, out = txt }
  return txt
end

local function tilde_path(p)
  local home = wezterm.home_dir
  if p:sub(1, #home) == home then
    p = "~" .. p:sub(#home + 1)
  end
  return p:gsub("/+$", "")
end

wezterm.on("update-status", function(window, pane)
  local cfg = window:effective_config()
  local pal = cfg.resolved_palette
  local cwd_uri = pane:get_current_working_dir()
  local cwd = ""
  if cwd_uri then
    cwd = cwd_uri.file_path or cwd_uri
  end

  local left = wezterm.format({
    { Foreground = { Color = pal.ansi[4] } },  -- blue-ish
    { Text = " " .. (window:active_workspace() or "") .. " " },
    { Foreground = { Color = pal.foreground } },
    { Text = "  " .. nf.dev_terminal .. " " .. (pane:get_foreground_process_name() or "shell") .. "  " },
  })
  window:set_left_status(left)

  local right = wezterm.format({
    { Foreground = { Color = pal.ansi[4] } },
    { Text = " " .. nf.md_folder .. " " },
    { Foreground = { Color = pal.foreground } },
    { Text = tilde_path(cwd) .. "  " },
    { Foreground = { Color = pal.ansi[7] } },  -- dim
    { Text = git_info(cwd) ~= "" and (" " .. nf.dev_git .. " ") or "" },
    { Foreground = { Color = pal.foreground } },
    { Text = git_info(cwd) },
    { Text = "  " },
  })
  window:set_right_status(right)
end)

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "SF Mono" }),
  font_size = 14.0,
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  window_decorations = "RESIZE",
  window_background_opacity = 0.95,
  adjust_window_size_when_changing_font_size = false,
}
