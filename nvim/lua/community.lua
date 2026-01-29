-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.motion.nvim-surround" },
  -- { import = "astrocommunity.completion.copilot-cmp" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.colorscheme.vscode-nvim" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.poimandres-nvim" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.utility.hover-nvim" },
  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.comment.ts-comments-nvim" },
  -- { import = "astrocommunity.indent.indent-rainbowline" },
  -- { import = "astrocommunity.indent.mini-indentscope" },

  -- import/override with your plugins folder
  --
  { import = "astrocommunity.media.cord-nvim" },
}
