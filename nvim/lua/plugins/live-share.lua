return {
  {
    "azratul/live-share.nvim",
    config = function()
      require("live-share").setup {
        username = "Marcos",
      }
    end,
  },

  -- P2P punch transport (alternative): enable this block and disable the one
  -- above to use direct peer-to-peer connections via the `punch` luarock.
  -- {
  --   "vhyrro/luarocks.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = true,
  --   opts = { rocks = { "punch >= 0.3.0" } },
  -- },
  -- {
  --   "azratul/live-share.nvim",
  --   dependencies = { "vhyrro/luarocks.nvim" },
  --   config = function()
  --     require("live-share").setup {
  --       transport = "punch",
  --       service = "bore",
  --       username = "Marcos",
  --     }
  --   end,
  -- },
}
