You already have vim-visual-multi enabled (via astrocommunity.editing-support.vim-visual-multi at nvim/lua/community.lua:27). That's the direct VSCode Cmd+D equivalent.

vim-visual-multi (multi-cursor, like Cmd+D)

With cursor on a word, in normal mode:

- Ctrl-n — select word under cursor (adds a cursor). Press again to add the next occurrence, and again, and again.
- n / N — jump to next/previous match without adding a cursor
- q — skip current match, jump to next (add a cursor there instead)
- Q — remove the current cursor
- [ / ] — move between your cursors
- Once you have all cursors placed, press c (change) or i (insert) or a (append), type new text, then Esc — the edit applies to every cursor.

So the full flow replacing foo with bar at N spots:

1. Put cursor on foo
2. Ctrl-n Ctrl-n Ctrl-n … (once per occurrence)
3. c bar Esc

You can also use Ctrl-n from visual mode to seed the match from an arbitrary selection, not just a word.

The idiomatic vim way (no plugin, often faster for "change every N")

For the common case "change the next few occurrences of a word":

1. - — searches for word under cursor (or /foo<CR> for arbitrary text)
2. cgn — change next match, type replacement, Esc
3. . — repeat on the next match
4. n — skip a match without changing it

cgn + . is the muscle-memory win: you get interactive, confirm-as-you-go replacement without leaving normal mode.

Project-wide / all occurrences in a buffer

- :%s/foo/bar/gc — substitute with confirmation (y/n/a/q)
- :%s/\<foo\>/bar/gc — whole-word only

For multi-file, AstroNvim ships with telescope + a grep/replace flow via :Spectre if you add it, but :cdo s/foo/bar/g | update over a quickfix list (from :grep / telescope's send-to-qflist) is the built-in path.

TL;DR: for your VSCode muscle memory, use Ctrl-n — it's already installed.
