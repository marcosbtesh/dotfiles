vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mail" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,es"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Soft-wrap long lines (e.g. long string values) for JSON files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})
