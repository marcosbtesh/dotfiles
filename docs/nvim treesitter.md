Created nvim/lua/plugins/treesitter-textobjects.lua.

What it does

Two specs in one file:

1. nvim-treesitter/nvim-treesitter-textobjects — the plugin itself. Lazy-loaded via User AstroFile (AstroNvim's event for "a real file was opened"), with nvim-treesitter declared as a dependency so parsers are ready first.
2. Extends nvim-treesitter/nvim-treesitter's opts — textobjects reads its config from require("nvim-treesitter.configs").setup({ textobjects = {...} }). Lazy deep-merges opts across specs, so this slots in alongside AstroNvim's own
   treesitter config without fighting it.

Keymaps you get

Motions (normal mode):

┌─────────┬────────────────────────────────┐
│ Key │ Jumps to │
├─────────┼────────────────────────────────┤
│ ]f / [f │ next / previous function start │
├─────────┼────────────────────────────────┤
│ ]F / [F │ next / previous function end │
├─────────┼────────────────────────────────┤
│ ]k / [k │ next / previous class start │
├─────────┼────────────────────────────────┤
│ ]K / [K │ next / previous class end │
└─────────┴────────────────────────────────┘

I used ]k/[k for class instead of the more common ]c/[c because AstroNvim's gitsigns already binds ]c/[c to "next/prev git hunk." If you don't care about that, change the keys in the file.

Text objects (use after any operator or in visual mode):

┌─────────┬───────────────────────────┐
│ Key │ Selects │
├─────────┼───────────────────────────┤
│ af / if │ around / inside function │
├─────────┼───────────────────────────┤
│ ac / ic │ around / inside class │
├─────────┼───────────────────────────┤
│ aa / ia │ around / inside parameter │
└─────────┴───────────────────────────┘

So to answer your original "jump to top of method" question, this gives you:

- [f — jump to the start of the current function (exactly what you asked about)
- vif — visually select the function body
- daf — delete the entire function
- cif — change the function body
- yaf — yank the whole function

lookahead = true on select means if your cursor is before a function, vaf will grab the next one — no need to be inside it.

set_jumps = true on move means every motion adds to the jump list, so Ctrl-o brings you back to where you started.

To activate

:Lazy sync

Then restart Neovim. Try [f / ]f inside any JS/TS/Python/Lua file.

One caveat — parser coverage

These motions only work for languages whose treesitter parser you have installed. You already have packs for TS/Python/Java/Dart/PHP/HTML/CSS/Lua, so those are covered. For anything else, :TSInstall <language> — or activate
nvim/lua/plugins/treesitter.lua (which has auto_install = true) so new filetypes install their parsers on demand.
