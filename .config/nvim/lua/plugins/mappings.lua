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

          -- delete/change without yanking
          ["d"] = { '"_d', desc = "Delete without yanking" },
          ["c"] = { '"_c', desc = "Change without yanking" },
          ["x"] = { '"_x', desc = "Delete char without yanking" },
          ["D"] = { '"_D', desc = "Delete to end of line without yanking" },
          ["C"] = { '"_C', desc = "Change to end of line without yanking" },
          ["s"] = { '"_s', desc = "Substitute char without yanking" },

          -- keep yank versions
          ["yd"] = { "d", desc = "Delete with yank" },
          ["yc"] = { "c", desc = "Change with yank" },
          ["yx"] = { "x", desc = "Delete char with yank" },
          ["yD"] = { "D", desc = "Delete to end of line with yank" },
          ["yC"] = { "C", desc = "Change to end of line with yank" },
          ["ys"] = { "s", desc = "Substitute char with yank" },
          
          -- undo / redo remaps
          ["U"] = { "u", desc = "Undo last change" }, -- Capital U as undo
          ["<Leader>r"] = { "<C-r>", desc = "Redo last undo" }, -- Redo without Ctrl-r conflict
        },

        v = {
          ["<A-S-Up>"] = { ":t'<-1<CR>gv", desc = "Copy selection up" },
          ["<A-S-Down>"] = { ":t'>+1<CR>gv", desc = "Copy selection down" },
          ["<A-k>"] = { ":t'<-1<CR>gv", desc = "Copy selection up (fallback)" },
          ["<A-j>"] = { ":t'>+1<CR>gv", desc = "Copy selection down (fallback)" },

          -- delete/change without yanking
          ["d"] = { '"_d', desc = "Delete without yanking" },
          ["c"] = { '"_c', desc = "Change without yanking" },
          ["x"] = { '"_x', desc = "Delete char without yanking" },
          ["D"] = { '"_D', desc = "Delete to end of line without yanking" },
          ["C"] = { '"_C', desc = "Change to end of line without yanking" },
          ["s"] = { '"_s', desc = "Substitute char without yanking" },

          -- keep yank versions
          ["yd"] = { "d", desc = "Delete with yank" },
          ["yc"] = { "c", desc = "Change with yank" },
          ["yx"] = { "x", desc = "Delete char with yank" },
          ["yD"] = { "D", desc = "Delete to end of line with yank" },
          ["yC"] = { "C", desc = "Change to end of line with yank" },
          ["ys"] = { "s", desc = "Substitute char with yank" },
        },
      },
    },
  },
}
