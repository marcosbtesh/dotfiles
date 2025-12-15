return {
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      auto_update = true,
      neovim_image_text = "AstroVim",
      main_image = "neovim",
      debounce_timeout = 10,
      enable_line_number = false,
      buttons = true,
      file_assets = {},
      show_time = true,

      editing_text = "Editing %s",
      file_explorer_text = "Browsing files",
      git_commit_text = "Committing changes",
      plugin_manager_text = "Managing plugins",
      reading_text = "Reading %s",
      -- workspace_text = "Working on %s",
      line_number_text = "Line %s out of %s",
    },
  },
}
