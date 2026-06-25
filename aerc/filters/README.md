# aerc filters

Custom [aerc](https://aerc-mail.org) filters for this dotfiles repo. Stowed into
`~/.config/aerc/filters/`, which aerc prepends to `$PATH`, so each script is
referenced by bare name in `aerc.conf`'s `[filters]` section.

## `html-preview` — browser-grade HTML email rendering

Renders the `text/html` part the way a real browser would (full CSS, web fonts,
gradients, tables) and shows it **inline** in the terminal, instead of w3m's
text-flattened output.

**Pipeline:** headless Chromium/Chrome → full-page PNG → ImageMagick `-trim` →
**sixel** inline in aerc's embedded terminal. Falls back automatically to an
external image viewer, then to a clean w3m / pandoc text render, so an email
never breaks.

Wired in `aerc.conf` as:

```ini
text/html=! html-preview
```

The leading `!` is required — it tells aerc to run the filter directly on the
embedded-terminal TTY (bypassing the pager) so graphics escape sequences reach
the host terminal. aerc forwards **sixel** specifically, which is why this
emits sixel rather than the kitty/iTerm2 protocols.

### Why sixel and not `wezterm imgcat`

aerc's documented working example is `text/html = ! html-unsafe -sixel`, i.e.
its embedded terminal forwards sixel to the host. The kitty and iTerm2 inline
protocols are *not* documented to pass through, so `wezterm imgcat` would be
swallowed by the embedded terminal. We target sixel for reliability.

### Configuration (environment variables)

| Variable               | Default | Meaning                                                        |
| ---------------------- | ------- | -------------------------------------------------------------- |
| `AERC_HTML_MODE`       | `auto`  | `auto` / `image` / `external` / `text`                         |
| `AERC_HTML_SAFE`       | `0`     | `1` = block all remote content (offline; no tracking pixels)   |
| `AERC_BROWSER`         | autodetect | explicit path to a Chromium/Chrome/Brave/Edge binary        |
| `AERC_HTML_WIDTH`      | `1024`  | render canvas width (px)                                       |
| `AERC_HTML_MAXHEIGHT`  | `4000`  | render canvas height (px); emails taller than this get cut     |
| `AERC_HTML_TIMEOUT`    | `30`    | max seconds to wait for a render                               |
| `AERC_HTML_CELLPX`     | `8`     | approx px per terminal cell (sixel sizing, ImageMagick path)   |
| `AERC_FORCE_GRAPHICS`  | `0`     | `1` = assume terminal supports sixel (skip detection)          |

Set these per-invocation, e.g. an offline-by-default alias:

```sh
alias email='AERC_HTML_SAFE=1 XDG_CONFIG_HOME="$HOME/.config" aerc'
```

### After an inline image renders

A footer offers: **q** close · **e** open in external browser · **t** text view.
(The wait also keeps the sixel on screen, since aerc may otherwise wipe it when
the filter process exits.)

### Privacy note

With `AERC_HTML_SAFE=0` (default), opening an email fetches its remote assets —
which can signal "email opened" to the sender (tracking pixels). Set
`AERC_HTML_SAFE=1` to render fully offline; layout/CSS still render, only
network-loaded images are skipped.

### Dependencies

- **Image mode:** a Chromium-family browser + ImageMagick (or `chafa`)
- **Better quality (optional):** `chafa` (cleaner scaling + cell-fit)
- **Text fallback:** `w3m` (preferred) or `pandoc`

Install commands are in the repo's `install_combined.sh`.

### Known limitations

- aerc pipes only the HTML part to the filter, so `cid:`-referenced inline
  attachments (multipart/related) don't resolve. Most modern marketing emails
  use remote `https` images, which load in the default (non-safe) mode.
- Very long emails are capped at `AERC_HTML_MAXHEIGHT`; use `e` (external
  viewer) for unbounded scrolling.
- sixel through **tmux** needs tmux ≥ 3.4 with sixel support and
  `allow-passthrough on` (already set in this repo's `tmux.conf`).
