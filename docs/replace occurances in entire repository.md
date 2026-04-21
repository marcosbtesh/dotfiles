With what you have now (Telescope + quickfix + ripgrep as the grep backend, no Spectre/grug-far), the canonical AstroNvim flow is Telescope live grep → quickfix list → :cfdo.

The flow

1. <Leader>fw — opens Telescope live grep across the project (ripgrep under the hood).
2. Type the word you want to replace. You'll see every match.
3. Refine if needed, then press <C-q> (Ctrl-q) inside Telescope — this sends all matches to the quickfix list and closes Telescope.
   - Optional: press <Tab> on individual entries first to multi-select, then <C-q> sends only the selected ones.

4. Run the substitution over every file in the quickfix:
   :cfdo %s/foo/bar/gc | update
   - cfdo = run the following command on every file in the quickfix list
   - %s/foo/bar/g = substitute on every line of that file
   - c flag = confirm each change (y/n/a = all in file / q = quit)
   - | update = save the file only if it changed

Useful variations of the substitute

┌──────────────────────────────────┬────────────────────────────────────────┐
│ Pattern │ Meaning │
├──────────────────────────────────┼────────────────────────────────────────┤
│ :cfdo %s/foo/bar/g | update │ no confirmation, change everything │
├──────────────────────────────────┼────────────────────────────────────────┤
│ :cfdo %s/\<foo\>/bar/gc | update │ whole-word only (won't touch foobar) │
├──────────────────────────────────┼────────────────────────────────────────┤
│ :cfdo %s/foo/bar/gcI | update │ case-sensitive with confirmation │
├──────────────────────────────────┼────────────────────────────────────────┤
│ :cfdo %s/foo/bar/gce | update │ e = don't error on files with no match │
└──────────────────────────────────┴────────────────────────────────────────┘

Add e if you get "Pattern not found" errors stopping the loop (happens when telescope sent a file where the exact regex doesn't match).

After running it

- :copen — open the quickfix list to browse remaining matches
- :cnext / :cprev — jump through them
- Trouble is also wired up (<Leader>xq opens quickfix in Trouble) if you prefer that UI.

Peek at quickfix before committing

If you want to see the list first rather than trust Telescope:

1. <Leader>fw, type query, <C-q>
2. :copen — review matches
3. :cfdo %s/…//gc | update when satisfied

Single-file only

Don't need multi-file? Just :%s/foo/bar/gc in the buffer — or the cgn + . flow I mentioned before.

TL;DR: <Leader>fw → type word → <C-q> → :cfdo %s/foo/bar/gc | update.

If you find yourself doing this often, grug-far.nvim or nvim-spectre give you a VSCode-style interactive Search & Replace panel (edit results in place, then apply) — worth adding one plugin for. But the quickfix flow above is the "pure
AstroNvim stock" answer.
