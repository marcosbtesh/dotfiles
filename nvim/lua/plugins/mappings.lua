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
