return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ltex-ls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          settings = {
            ltex = {
              language = "auto", -- auto-detects English/Spanish
              additionalRules = {
                enablePickyRules = true,
              },
            },
          },
          filetypes = { "mail", "markdown", "text" },
        },
      },
    },
  },
}
