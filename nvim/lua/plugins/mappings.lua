-- lua/plugins/mappings.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Move line up/down (like VS Code Alt+Up/Alt+Down)
          ["<A-Up>"] = { ":m .-2<CR>==", desc = "Move line up" },
          ["<A-Down>"] = { ":m .+1<CR>==", desc = "Move line down" },
          ["<A-k>"] = { ":m .-2<CR>==", desc = "Move line up (fallback)" },
          ["<A-j>"] = { ":m .+1<CR>==", desc = "Move line down (fallback)" },

          -- Copy line up/down (Shift+Alt)
          ["<A-S-Up>"] = { ":t.-1<CR>==", desc = "Copy line up" },
          ["<A-S-Down>"] = { ":t.<CR>==", desc = "Copy line down" },

          -- paste from last yank (register 0), unaffected by recent deletes
          ["<Leader>P"] = { '"0p', desc = "Paste last yank after" },

          -- undo / redo remaps
          ["U"] = { "u", desc = "Undo last change" },
          ["<Leader>r"] = { "<C-r>", desc = "Redo last undo" },
        },

        v = {
          -- Move selected block up/down
          ["<A-Up>"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" },
          ["<A-Down>"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" },
          ["<A-k>"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up (fallback)" },
          ["<A-j>"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down (fallback)" },

          -- Copy selection up/down (Shift+Alt)
          ["<A-S-Up>"] = { ":t'<-1<CR>gv", desc = "Copy selection up" },
          ["<A-S-Down>"] = { ":t'>+1<CR>gv", desc = "Copy selection down" },

          -- paste over selection without yanking the replaced text
          ["<Leader>p"] = { '"_dP', desc = "Paste without yanking" },
        },
      },
    },
  },
}
