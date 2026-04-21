-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Allow per-project .nvim.lua files (used for project-local DAP configs, etc.)
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.timeoutlen = 500
