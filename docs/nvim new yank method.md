Done. Here's what changed in nvim/lua/plugins/mappings.lua:

Removed:

- All the "\_d / "\_c / "\_x / "\_D / "\_C / "\_s remaps in both normal and visual mode
- All the <Leader>y\* leader-prefixed yanking versions (no longer needed — d/c/x/etc. now yank by default, which is vanilla vim behavior)

Added:

- <Leader>p in visual mode → "\_dP — paste over a selection without clobbering your register (the quoted suggestion)
- <Leader>P in normal mode → "0p — paste from register 0 (the "last yank" register, which is never touched by deletes). This gives you the "paste what I last yanked, even if I've done some deletes since" escape hatch.

Kept unchanged:

- <A-Up>/<A-Down> line move (VSCode muscle memory)
- <A-S-Up>/<A-S-Down> line copy
- U → undo, <Leader>r → redo

How your common flows work now

┌────────────────────────────────────┬─────────────────────┬───────────────────────────────────────────────┐
│ Flow │ Keys │ What happens │
├────────────────────────────────────┼─────────────────────┼───────────────────────────────────────────────┤
│ Yank paragraph, paste elsewhere │ yap → move → p │ ✅ works (always did) │
├────────────────────────────────────┼─────────────────────┼───────────────────────────────────────────────┤
│ Cut paragraph, paste elsewhere │ dap → move → p │ ✅ works again (was broken) │
├────────────────────────────────────┼─────────────────────┼───────────────────────────────────────────────┤
│ Copy word, replace another word │ yiw → viw <Leader>p │ ✅ replaces selection, keeps word in register │
├────────────────────────────────────┼─────────────────────┼───────────────────────────────────────────────┤
│ Delete, then retrieve earlier yank │ daw → <Leader>P │ ✅ pastes the yank, not the delete │
├────────────────────────────────────┼─────────────────────┼───────────────────────────────────────────────┤
│ Want a true black-hole delete │ "\_daw, "\_ciw, "\_x │ Explicit when you want it │
└────────────────────────────────────┴─────────────────────┴───────────────────────────────────────────────┘

The explicit "\_ prefix takes two extra keystrokes when you actually want black hole — that's the small price for not surprising yourself months later.
