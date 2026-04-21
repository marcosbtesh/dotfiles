This is built into Vim — no plugin needed. The feature is called marks.

Setting and jumping to marks

In normal mode:

- m{a-z} — set a lowercase mark (local to the current file). Example: ma sets mark a at the cursor position.
- m{A-Z} — set an uppercase mark (global — remembers both the file and the position). Example: mA sets mark A.
- `a (backtick + letter) — jump to mark a (exact line and column).
- 'a (apostrophe + letter) — jump to the line of mark a (first non-blank char).

Your use case: marking spots across multiple files

Use uppercase marks (A–Z). They persist across files and across Neovim sessions (stored in shada).

Workflow:

1. In file1.lua, put cursor on the spot → mA
2. Switch to file2.lua, another spot → mB
3. Open a third file → mC
4. From anywhere: `A jumps you back to file1.lua at the exact position. `B to file2.lua. Etc.

` (backtick) is what you want — it restores the exact column too. ' only goes to the line.

Listing and managing marks

- :marks — list all marks (file, line, column, text of the line)
- :marks ABC — list only specific marks
- :delmarks A — delete mark A
- :delmarks! — delete all lowercase marks in the current buffer

AstroNvim also gives you Telescope for this: :Telescope marks lets you fuzzy-search marks and preview the line.

Automatic marks worth knowing

These are set for you — no m needed:

┌──────────────────────┬─────────────────────────────────────────────────────────────┐
│ Mark │ What it does │
├──────────────────────┼─────────────────────────────────────────────────────────────┤
│ ``(two backticks) │ Position before the last jump — toggle between two spots    │
  ├──────────────────────┼─────────────────────────────────────────────────────────────┤
  │`. │ Position of the last change │
├──────────────────────┼─────────────────────────────────────────────────────────────┤
│ `^                   │ Position where insert mode was last exited                  │
  ├──────────────────────┼─────────────────────────────────────────────────────────────┤
  │ `[` / `]`           │ Start / end of last changed or yanked text                  │
  ├──────────────────────┼─────────────────────────────────────────────────────────────┤
  │`< / `>              │ Start / end of last visual selection                        │
  ├──────────────────────┼─────────────────────────────────────────────────────────────┤
  │ `0 … `9 │ Cursor position when Neovim last exited (most recent files) │
└──────────────────────┴─────────────────────────────────────────────────────────────┘

    `` is the one you'll reach for constantly — it's "go back to where I was before I jumped."

Related: jump list (often better than marks)

You don't always need to set a mark — Neovim already tracks your jumps:

- Ctrl-o — jump back to previous location (across files)
- Ctrl-i (or Tab) — jump forward again
- :jumps — list the jump list

So if you gd (go to definition) or search somewhere, Ctrl-o brings you home. Most of the time this replaces the need for manual marks.

And the change list (similar but for edits):

- g; — previous change
- g, — next change

If you do this a lot: harpoon

For "I'm juggling 3–4 files and want instant switching," the community plugin most Neovim users add for this exact workflow is harpoon (ThePrimeagen's). You "pin" files to slots 1–4 and jump with <Leader>1, <Leader>2, etc. It's in
astrocommunity as astrocommunity.motion.harpoon if you want to add it. But you don't have it today — uppercase marks cover the same ground, just with letters instead of numbers.

TL;DR: mA to set, `A to jump back. Uppercase = cross-file.
