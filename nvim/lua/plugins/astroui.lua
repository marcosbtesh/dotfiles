-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- Enable transparency for the main editor windows
    highlights = {
      -- use a function override to set highlights for all themes
      global = function(highlights)
        highlights.Normal = { bg = "NONE" }
        highlights.NormalNC = { bg = "NONE" }
        highlights.CursorLine = { bg = "NONE" }
        highlights.CursorLineNr = { bg = "NONE" }
        highlights.StatusLine = { bg = "NONE" }
        highlights.StatusLineNC = { bg = "NONE" }
        highlights.SignColumn = { bg = "NONE" }
        highlights.FoldColumn = { bg = "NONE" }
        return highlights
      end,
    },
  },
}
