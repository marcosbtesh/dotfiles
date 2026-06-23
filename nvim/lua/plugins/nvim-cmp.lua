-- Extends AstroNvim's nvim-cmp (enabled by `astrocommunity.completion.nvim-cmp`
-- in community.lua) to match the upstream nvim-cmp README, adapted to
-- AstroNvim v6:
--
--   • cmdline completion for `/`, `?` and `:` — the one piece AstroNvim does
--     not set up by default, and the bulk of the README's extra config.
--   • the README's insert-mode keymaps (<C-b>/<C-f>/<C-Space>/<C-e>/<CR>),
--     layered ON TOP of AstroNvim's mappings rather than replacing them so the
--     <Tab>/<S-Tab> LuaSnip jumping, <Up>/<Down>, <C-P>/<C-N> etc. still work.
--   • the AI source from minuet-ai (LM Studio + other providers, see
--     `minuet-ai.lua`), plus a manual trigger on <A-y>.
--
-- Intentionally NOT redone here — AstroNvim already provides it:
--   • installing nvim-cmp and the nvim_lsp / buffer / path sources,
--   • the snippet engine (AstroNvim uses LuaSnip, NOT vsnip as in the README),
--   • wiring cmp_nvim_lsp capabilities into every LSP server (so the README's
--     `vim.lsp.config('<server>', { capabilities = ... })` step is unnecessary).

---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-cmdline", -- `:` command-line completion source
    "milanglacier/minuet-ai.nvim", -- AI completion source (configured in minuet-ai.lua)
  },
  -- Also load on the command line so `:` / `/` completion is available before
  -- you've entered insert mode (AstroNvim only loads cmp on InsertEnter).
  event = { "CmdlineEnter" },
  opts = function(_, opts)
    local cmp = require "cmp"

    -- README insert/cmdline mappings, merged over AstroNvim's defaults.
    opts.mapping = opts.mapping or {}
    opts.mapping["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" })
    opts.mapping["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" })
    opts.mapping["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
    opts.mapping["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" })
    -- README uses select = true: <CR> accepts the first item even when nothing
    -- is explicitly selected. Set select = false if you'd rather <CR> only
    -- confirm an item you actually highlighted.
    -- NOTE: scoped to insert mode "i" only — NOT command mode "c". With "c" here,
    -- pressing <CR> on the `:` line auto-confirmed the first cmdline suggestion,
    -- turning `:w`→`:write`, `:wq`/`:qa`→their first match, etc. Leaving "c" off
    -- means <CR> runs the literal command; use <Tab> to pick from the popup.
    opts.mapping["<CR>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i" })

    -- Manual AI trigger: ask minuet for suggestions on demand (handy when AI
    -- auto-complete is turned off for a paid provider). <A-y> = Alt/Option-y;
    -- on macOS terminals enable "Use Option as Meta" or rebind to taste.
    local minuet_avail, minuet = pcall(require, "minuet")
    if minuet_avail then opts.mapping["<A-y>"] = minuet.make_cmp_map() end

    -- Add the AI source to the normal completion menu. Low priority so it ranks
    -- below the native LSP (1000) / luasnip (750) / buffer (500) / path (250).
    opts.sources = opts.sources or {}
    table.insert(opts.sources, { name = "minuet", group_index = 1, priority = 100 })

    -- Give async AI suggestions time to arrive before the menu is drawn.
    opts.performance = opts.performance or {}
    opts.performance.fetching_timeout = 2000

    return opts
  end,
  config = function(_, opts)
    local cmp = require "cmp"

    -- Mirror AstroNvim's own nvim-cmp config: it isn't exposed as a reusable
    -- module, and defining `config` here replaces it, so we reproduce its two
    -- steps (default source group_index + autopairs hook) before extending it.
    for _, source in ipairs(opts.sources or {}) do
      if not source.group_index then source.group_index = 1 end
    end
    cmp.setup(opts)
    local autopairs_avail, autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if autopairs_avail then cmp.event:on("confirm_done", autopairs.on_confirm_done { tex = false }) end

    -- ── The README's command-line completion (the actual new behaviour) ──────
    -- `/` and `?` search: complete words from the current buffer.
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- `:` commands: complete paths, then command-line names/arguments.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
}
