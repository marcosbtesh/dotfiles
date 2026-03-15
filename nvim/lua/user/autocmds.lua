vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mail" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,es"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
