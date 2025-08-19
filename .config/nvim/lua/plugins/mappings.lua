-- lua/plugins/mappings.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<A-S-Up>"] = { ":t.-1<CR>==", desc = "Copy line up" },
          ["<A-S-Down>"] = { ":t.<CR>==", desc = "Copy line down" },
          ["<A-k>"] = { ":t.-1<CR>==", desc = "Copy line up (fallback)" },
          ["<A-j>"] = { ":t.<CR>==", desc = "Copy line down (fallback)" },
        },
        v = {
          ["<A-S-Up>"] = { ":t'<-1<CR>gv", desc = "Copy selection up" },
          ["<A-S-Down>"] = { ":t'>+1<CR>gv", desc = "Copy selection down" },
          ["<A-k>"] = { ":t'<-1<CR>gv", desc = "Copy selection up (fallback)" },
          ["<A-j>"] = { ":t'>+1<CR>gv", desc = "Copy selection down (fallback)" },
        },
      },
    },
  },
}
