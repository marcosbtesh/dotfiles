# Corne 4.1 (46-key) Keymap — QMK Reference

A keymap optimized for **everyday typing + Neovim (AstroNvim)**, designed for someone coming from standard US-QWERTY. Targets a 46-key Corne 4.1 (42 keys + 4 inner-column extras where the OLED used to sit).

---

## Table of contents

1. [Design philosophy](#design-philosophy)
2. [Layer 0 — Base](#layer-0--base)
3. [Layer 1 — Nav](#layer-1--nav)
4. [Layer 2 — Sym](#layer-2--sym)
5. [Layer 3 — Num / Function](#layer-3--num--function)
6. [Home-row mods (GACS)](#home-row-mods-gacs)
7. [Combos](#combos)
8. [Tri-layer (Nav + Sym → Num)](#tri-layer-nav--sym--num)
9. [Tuning parameters (`config.h`)](#tuning-parameters-configh)
10. [Features to enable (`rules.mk`)](#features-to-enable-rulesmk)
11. [Drop-in QMK `keymap.c`](#drop-in-qmk-keymapc)
12. [Importing the JSON into config.qmk.fm](#importing-the-json-into-configqmkfm)
13. [Learning curve — first week plan](#learning-curve--first-week-plan)

---

## Design philosophy

| Goal                                                    | How it's achieved                                                                                                                            |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Zero letter-learning curve                              | QWERTY letter layout preserved exactly                                                                                                       |
| No pinky gymnastics for modifiers                       | Home-row mods (GACS): GUI/Alt/Ctrl/Shift on A/S/D/F (mirrored J/K/L/;)                                                                       |
| SPACE is `<Leader>` in AstroNvim → must be a _pure_ tap | SPACE and ENTER are single-function `KC_SPC` / `KC_ENT` — no mod-tap, no layer-tap                                                           |
| Fast, safe HRM                                          | `balanced` flavor (hold resolves only on opposite-hand chord) + `TAPPING_TERM_PER_KEY` + `QUICK_TAP_TERM` to kill misfires during fast rolls |
| Classic vim Esc                                         | Outer-home left key is tap-Esc / hold-Ctrl (muscle memory from old `CapsLock→Ctrl` remap culture)                                            |
| Symbols optimized for programming                       | Shifted-number row familiar `! @ # $ %` on top-left; `= - + { }` on home row (most-pressed code symbols on strongest fingers)                |
| Number row is missing → don't waste taps getting there  | Right-hand numpad (7/8/9, 4/5/6, 1/2/3) on NUM layer; reached via `NAV + SYM` tri-layer                                                      |
| Arrows must be reachable without leaving home row       | NAV layer puts arrows on H/J/K/L (vim-shape); Ctrl+arrow for word-jumps on N/M/,/. (one row below)                                           |
| Clipboard muscle memory stays QWERTY                    | NAV layer maps Z/X/C/V/B positions to `C-Z / C-X / C-C / C-V / C-Y` (undo/cut/copy/paste/redo)                                               |
| 4 OLED-replacement keys must pull their weight          | Base: dedicated `ESC / TAB / BSPC / DEL` (always-useful redundant utility keys, no chance of misfire since they're single-function)          |
| One combo, not ten                                      | F+J → `CAPS_WORD`. Anything more causes misfires during the HRM learning curve.                                                              |
| Everyday typing still feels normal                      | `require-prior-idle` on HRM means any key typed within ~150ms of another is forced to tap — prevents `the` from becoming `Te` etc.           |

### Why home-row mods at all?

On a 42-key corne the alternative is pinky-reach modifiers — which is exactly what made your original QWERTY uncomfortable. HRM gives you **Shift without pinky strain** (huge for nvim, where every capital letter is a command: `G`, `N`, `A`, `I`, `O`, `D`, `C`, `U`, `V`, `R`), plus **cheap `<C-*>` and `<A-*>` combos** (which your AstroNvim config uses constantly for `<C-r>`, `<C-u>`, `<C-d>`, `<A-j>`, `<A-k>`, `<A-Up>`, `<A-S-Down>`, etc.).

The learning curve is ~1–2 weeks. After that you can't go back.

### Why keep `<A-j>` / `<A-k>` as line-move instead of duplicating with right alt?

Your `mappings.lua` already has both `<A-Up>/<A-Down>` and `<A-k>/<A-j>` aliased to the same commands. The HRM layout puts Alt on S and L — so `<A-j>` is `S-hold + J-tap` (comfortable, opposite hand). `<A-Up>` becomes `S-hold + (NAV)Up` = three keys. Either works.

---

## Layer 0 — Base

```
┌─────────┬─────┬─────┬─────┬─────┬─────┐                         ┌─────┬─────┬─────┬─────┬─────┬─────────┐
│  TAB    │  Q  │  W  │  E  │  R  │  T  │                         │  Y  │  U  │  I  │  O  │  P  │  BSPC   │
├─────────┼─────┼─────┼─────┼─────┼─────┤   ┌─────┐     ┌─────┐   ├─────┼─────┼─────┼─────┼─────┼─────────┤
│ ESC/CTL │ A/⌘ │ S/⌥ │ D/⌃ │ F/⇧ │  G  │   │ ESC │     │BSPC │   │  H  │ J/⇧ │ K/⌃ │ L/⌥ │ ;/⌘ │    '    │
├─────────┼─────┼─────┼─────┼─────┼─────┤   ├─────┤     ├─────┤   ├─────┼─────┼─────┼─────┼─────┼─────────┤
│  LSHFT  │  Z  │  X  │  C  │  V  │  B  │   │ TAB │     │ DEL │   │  N  │  M  │  ,  │  .  │  /  │   ESC   │
└─────────┴─────┴─────┼─────┼─────┼─────┤   └─────┘     └─────┘   ├─────┼─────┼─────┼─────┴─────┴─────────┘
                      │ GUI │ NAV │ SPC │                         │ RET │ SYM │ ALT │
                      │     │+TAB │     │                         │     │+BSPC│     │
                      └─────┴─────┴─────┘                         └─────┴─────┴─────┘
```

### Key assignments (QMK)

| Position          | Key       | QMK keycode         | Rationale                                                                       |
| ----------------- | --------- | ------------------- | ------------------------------------------------------------------------------- |
| Top-L outer       | TAB       | `KC_TAB`            | Classic position; used for completion and `]b` buffer nav                       |
| Home-L outer      | Esc/Ctrl  | `LCTL_T(KC_ESC)`    | Tap=Esc (mode switch), Hold=Ctrl. Classic CapsLock→Ctrl+Esc remap for vim users |
| Bot-L outer       | L-Shift   | `KC_LSFT`           | Backup Shift; HRM is primary                                                    |
| Top-R outer       | Backspace | `KC_BSPC`           | Standard                                                                        |
| Home-R outer      | `'`       | `KC_QUOT`           | Keeps natural QWERTY position (ltex-ls for Spanish apostrophes too)             |
| Bot-R outer       | Esc       | `KC_ESC`            | Preserved from your previous layout; triple redundancy is cheap                 |
| L thumb 1 (outer) | GUI       | `KC_LGUI`           | Super/Cmd for window manager shortcuts                                          |
| L thumb 2 (mid)   | Nav/Tab   | `LT(_NAV, KC_TAB)`  | Tap=Tab, Hold=Nav layer                                                         |
| L thumb 3 (inner) | Space     | `KC_SPC`            | **Pure tap — it's your `<Leader>`**                                             |
| R thumb 3 (inner) | Enter     | `KC_ENT`            | Pure tap — line endings are hot                                                 |
| R thumb 2 (mid)   | Sym/Bspc  | `LT(_SYM, KC_BSPC)` | Tap=Backspace, Hold=Sym layer                                                   |
| R thumb 1 (outer) | Alt       | `KC_RALT`           | Right Alt = AltGr on Linux (accents, Spanish chars)                             |
| Inner-L top       | Esc       | `KC_ESC`            | Bonus fourth Esc, pure                                                          |
| Inner-L bot       | Tab       | `KC_TAB`            | Bonus second Tab                                                                |
| Inner-R top       | Bspc      | `KC_BSPC`           | Bonus second Bspc                                                               |
| Inner-R bot       | Del       | `KC_DEL`            | Forward delete (otherwise only on NAV)                                          |

### Home row (HRM, GACS)

| Key | QMK               | Tap | Hold    |
| --- | ----------------- | --- | ------- |
| A   | `LGUI_T(KC_A)`    | `a` | ⌘/Super |
| S   | `LALT_T(KC_S)`    | `s` | Alt     |
| D   | `LCTL_T(KC_D)`    | `d` | Ctrl    |
| F   | `LSFT_T(KC_F)`    | `f` | Shift   |
| J   | `RSFT_T(KC_J)`    | `j` | Shift   |
| K   | `RCTL_T(KC_K)`    | `k` | Ctrl    |
| L   | `LALT_T(KC_L)`    | `l` | Alt     |
| `;` | `RGUI_T(KC_SCLN)` | `;` | ⌘/Super |

**Mnemonic: G-A-C-S (GUI-Alt-Ctrl-Shift), Shift closest to index.** Shift is the most-pressed modifier → assigned to the strongest finger. GUI is the least-pressed → assigned to the pinky.

---

## Layer 1 — Nav

Activated by **holding left-thumb-middle** (`LT(_NAV, KC_TAB)`).

```
┌─────┬─────┬─────┬─────┬─────┬─────┐                         ┌─────┬─────┬─────┬─────┬─────┬─────┐
│     │     │     │     │     │     │                         │HOME │PGDN │PGUP │ END │ INS │ DEL │
├─────┼─────┼─────┼─────┼─────┼─────┤   ┌─────┐     ┌─────┐   ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │ GUI │ ALT │CTRL │SHFT │     │   │     │     │     │   │LEFT │DOWN │ UP  │RIGHT│ TAB │CAPS │
├─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┤     ├─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │UNDO │ CUT │COPY │PSTE │REDO │   │     │     │     │   │C-LF │C-DN │C-UP │C-RT │     │     │
└─────┴─────┴─────┼─────┼─────┼─────┤   └─────┘     └─────┘   ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │     │     │     │                         │     │     │     │
                  └─────┴─────┴─────┘                         └─────┴─────┴─────┘
```

### Rationale

- **Right-hand arrows on H/J/K/L (vim shape)** — zero context-switch from `nvim`'s native motion.
- **Ctrl+arrows on the row below** (N/M/,/.) — word-jump in any text field (browser URL bar, Slack, VS Code, etc.).
- **Home/PgDn/PgUp/End on row above** — document navigation in one row.
- **Left-home-row explicit modifiers** (`KC_LGUI`, `KC_LALT`, `KC_LCTL`, `KC_LSFT`) — so when you want `Shift+Arrow` to select text, you press _left-hand Shift_ (explicit, no tap-hold delay) + _right-hand arrow_. This is faster than relying on HRM during Nav sequences.
- **Clipboard macros (Z/X/C/V/B)** — kept at QWERTY positions so `C-Z`, `C-X`, `C-C`, `C-V`, `C-Y` muscle memory transfers. Especially useful outside nvim (browser, terminal).
- **CAPS on `;` position** — toggle caps lock; rare-but-useful.

### QMK keycodes

| Pos                      | Code                                                      |
| ------------------------ | --------------------------------------------------------- |
| H/J/K/L                  | `KC_LEFT` / `KC_DOWN` / `KC_UP` / `KC_RGHT`               |
| Above arrows (U/I/O row) | `KC_PGDN` / `KC_PGUP` / `KC_END`                          |
| Y position               | `KC_HOME`                                                 |
| P / `[` position         | `KC_INS` / `KC_DEL`                                       |
| `;` / `'` row            | `KC_TAB` / `KC_CAPS`                                      |
| Bottom-right arrow row   | `C(KC_LEFT)` / `C(KC_DOWN)` / `C(KC_UP)` / `C(KC_RGHT)`   |
| Z / X / C / V / B        | `C(KC_Z)` / `C(KC_X)` / `C(KC_C)` / `C(KC_V)` / `C(KC_Y)` |
| Home row L               | `KC_LGUI` / `KC_LALT` / `KC_LCTL` / `KC_LSFT`             |
| Everything else          | `KC_TRNS`                                                 |

---

## Layer 2 — Sym

Activated by **holding right-thumb-middle** (`LT(_SYM, KC_BSPC)`).

```
┌─────┬─────┬─────┬─────┬─────┬─────┐                         ┌─────┬─────┬─────┬─────┬─────┬─────┐
│     │  !  │  @  │  #  │  $  │  %  │                         │  ^  │  &  │  *  │  '  │  "  │BSPC │
├─────┼─────┼─────┼─────┼─────┼─────┤   ┌─────┐     ┌─────┐   ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │  =  │  -  │  +  │  {  │  }  │   │     │     │     │   │  |  │  /  │  \  │  (  │  )  │  `  │
├─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┤     ├─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │  ~  │  <  │  >  │  [  │  ]  │   │     │     │     │   │  ?  │  _  │  :  │  ;  │  ,  │  .  │
└─────┴─────┴─────┼─────┼─────┼─────┤   └─────┘     └─────┘   ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │     │     │     │                         │     │     │     │
                  └─────┴─────┴─────┘                         └─────┴─────┴─────┘
```

### Rationale

- **Layer is held by the RIGHT thumb**, so symbols are placed **mostly on the LEFT hand** (opposite-hand chord = no finger contention).
- **Top-left row = shifted-number row** (`! @ # $ %`) — **preserves QWERTY muscle memory exactly**. When you think "$", your ring finger still goes to the same place as on a regular keyboard.
- **Home-row LEFT = `= - + { }`** — the five most-typed programming symbols go on the strongest fingers:
  - `=` on A (assignment, comparison — _very_ frequent)
  - `-` on S
  - `+` on D
  - `{` on F (index finger, inward roll to)
  - `}` on G (index, natural follow-up to `{`)
- **Bottom-row LEFT = `~ < > [ ]`** — less-frequent but still used; kept on left for hold-side consistency.
- **Right-hand SYM side carries parens, quotes, pipe, slashes, backtick** — you sometimes do need them while right-hand is holding. Put them on right too so you're not forced to release-re-hold for a `()`.
- `(` and `)` on **right-hand home row (O and P positions)** — rolling-pair on the ring/pinky.
- **`,` and `.` on sym-layer right row 3** = same QWERTY positions — so you don't lose them when sym is held mid-sentence.

### QMK keycodes

Left half, row by row:

| Row | Q         | W         | E         | R         | T         |
| --- | --------- | --------- | --------- | --------- | --------- |
| 1   | `KC_EXLM` | `KC_AT`   | `KC_HASH` | `KC_DLR`  | `KC_PERC` |
| 2   | `KC_EQL`  | `KC_MINS` | `KC_PLUS` | `KC_LCBR` | `KC_RCBR` |
| 3   | `KC_TILD` | `KC_LT`   | `KC_GT`   | `KC_LBRC` | `KC_RBRC` |

_(Row 2 and Row 3 start at Q column; outer pinky column is `KC_TRNS` so LSFT and `LCTL_T(KC_ESC)` stay live.)_

Right half, row by row:

| Row | Y         | U         | I         | O         | P         | outer     |
| --- | --------- | --------- | --------- | --------- | --------- | --------- |
| 1   | `KC_CIRC` | `KC_AMPR` | `KC_ASTR` | `KC_QUOT` | `KC_DQUO` | `KC_BSPC` |
| 2   | `KC_PIPE` | `KC_SLSH` | `KC_BSLS` | `KC_LPRN` | `KC_RPRN` | `KC_GRV`  |
| 3   | `KC_QUES` | `KC_UNDS` | `KC_COLN` | `KC_SCLN` | `KC_COMM` | `KC_DOT`  |

---

## Layer 3 — Num / Function

Activated by **holding both NAV and SYM** thumbs (tri-layer — no dedicated key needed).

```
┌─────┬─────┬─────┬─────┬─────┬─────┐                         ┌─────┬─────┬─────┬─────┬─────┬─────┐
│BT_C │ BT1 │ BT2 │ BT3 │ BT4 │ BT5 │                         │  /  │  7  │  8  │  9  │  -  │RESET│
├─────┼─────┼─────┼─────┼─────┼─────┤   ┌─────┐     ┌─────┐   ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │ F1  │ F2  │ F3  │ F4  │ F5  │   │     │     │     │   │  *  │  4  │  5  │  6  │  +  │  =  │
├─────┼─────┼─────┼─────┼─────┼─────┤   ├─────┤     ├─────┤   ├─────┼─────┼─────┼─────┼─────┼─────┤
│BOOT │ F6  │ F7  │ F8  │ F9  │ F10 │   │     │     │     │   │  0  │  1  │  2  │  3  │  .  │  _  │
└─────┴─────┴─────┼─────┼─────┼─────┤   └─────┘     └─────┘   ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │     │     │     │                         │     │     │     │
                  └─────┴─────┴─────┘                         └─────┴─────┴─────┘
```

### Rationale

- **Numpad layout on the right hand** (7/8/9 top, 4/5/6 middle, 0/1/2/3 bottom) — the universal numpad; any accountant-brain recognizes it. `0` on the pinky is a deliberate choice so it's reachable with the thumb from `KC_SPC` position.
- **Numpad operators on the far-left of the right half** (`/ * + -`) — the pinky column. Lets you type expressions like `3 + 4` without moving your hand.
- **F-keys on the left hand** — F1/F2 for browser tabs, F5 for refresh, F10/F11/F12 for tools. Grouped in natural rows so you don't hunt.
- **Bluetooth / bootloader** live on this layer since they're accessed so rarely that a 3-key chord (hold NAV + hold SYM + tap) is an acceptable safety interlock against misfires.
  - **Note**: QMK/USB Corne has no Bluetooth. Replace those with `KC_MUTE`, `KC_VOLU`, `KC_VOLD`, `KC_MPLY`, `KC_MPRV`, `KC_MNXT` for media control (see `keymap.c` template below).

### QMK keycodes (USB Corne, BT replaced with media)

Left half:

| Row                   | col 2     | col 3     | col 4     | col 5     | col 6     |
| --------------------- | --------- | --------- | --------- | --------- | --------- |
| 1 (outer = `KC_MUTE`) | `KC_VOLD` | `KC_VOLU` | `KC_MPRV` | `KC_MPLY` | `KC_MNXT` |
| 2 (outer = TRNS)      | `KC_F1`   | `KC_F2`   | `KC_F3`   | `KC_F4`   | `KC_F5`   |
| 3 (outer = `QK_BOOT`) | `KC_F6`   | `KC_F7`   | `KC_F8`   | `KC_F9`   | `KC_F10`  |

Right half:

| Row | Y         | U       | I       | O       | P         | outer     |
| --- | --------- | ------- | ------- | ------- | --------- | --------- |
| 1   | `KC_PSLS` | `KC_P7` | `KC_P8` | `KC_P9` | `KC_PMNS` | `QK_RBT`  |
| 2   | `KC_PAST` | `KC_P4` | `KC_P5` | `KC_P6` | `KC_PPLS` | `KC_EQL`  |
| 3   | `KC_P0`   | `KC_P1` | `KC_P2` | `KC_P3` | `KC_PDOT` | `KC_UNDS` |

> `KC_P0..KC_P9` generate real numpad scancodes (useful because some apps distinguish them from top-row numbers). You can swap for `KC_0..KC_9` if you want identical behavior.

---

## Home-row mods (GACS)

### The rule

- **Left hand**: A=GUI, S=Alt, D=Ctrl, F=Shift
- **Right hand (mirror)**: `;`=GUI, L=Alt, K=Ctrl, J=Shift

### Why this order (GACS not GASC)?

| Finger | Strength  | Use frequency of mod        |
| ------ | --------- | --------------------------- |
| Pinky  | weakest   | GUI (rarely used alone)     |
| Ring   | medium    | Alt                         |
| Middle | strong    | Ctrl                        |
| Index  | strongest | Shift (_highest_ frequency) |

In vim alone: every capital letter is a command — `G`, `A`, `I`, `O`, `N`, `D`, `C`, `U`, `V`, `R`, `$`, `%`, `^`, `*`. Shift is hit constantly. Assigning it to the strongest finger (index) is the biggest comfort win of HRM.

### Misfire prevention

Three mechanisms stacked:

1. **`TAPPING_TERM` = 200ms** — baseline threshold for "is this a hold?"
2. **`QUICK_TAP_TERM` = 175ms** — if you tap the same mod-tap key twice quickly, the second is forced to tap (so `aa` types normally).
3. **Opposite-hand trigger only** (via `HRM_BALANCED` / `PERMISSIVE_HOLD_PER_KEY` + `get_hold_on_other_key_press_per_key`) — if the next key is same-hand, HRM falls back to tap. Kills rolls like `fs` becoming `Shift+S`.
4. **`QUICK_TAP_TERM` per-key for HRM** → 0 for HRM keys (so a held-then-released HRM during fast typing still yields letter, not mod).

See the `config.h` section below for exact values.

### Common concern: doesn't `the` become `Te`?

With `TAPPING_TERM_PER_KEY` + balanced flavor + ~150ms prior-idle guard — if you just typed a letter less than ~150ms ago, the next HRM key is **forced to tap**. Fast typing (where keys are <150ms apart) is safe. Deliberate chording (e.g. `F`-hold-then-`J`) has a natural pause built in.

---

## Combos

Only one, by design — more causes misfires during the HRM learning curve.

| Combo                                                 | Output      | Use case                                                                                      |
| ----------------------------------------------------- | ----------- | --------------------------------------------------------------------------------------------- |
| F + J (both home-row index keys, pressed within 40ms) | `CAPS_WORD` | Type the next word in ALL_CAPS (auto-ends on space/punct). Perfect for `SCREAMING_CONSTANTS`. |

**QMK setup**: define as a 2-key combo in `combos.def` or the combo array, mapping to `CW_TOGG`.

Once you're comfortable, optional additions (after the first month):

| Combo | Output    | Notes                               |
| ----- | --------- | ----------------------------------- |
| Q + W | `KC_ESC`  | Backup escape (corner, low-misfire) |
| O + P | `KC_BSPC` | Backup backspace                    |
| Z + / | `QK_BOOT` | Hard-to-press-by-accident reset     |

---

## Tri-layer (Nav + Sym → Num)

When both NAV and SYM are held simultaneously, the NUM layer activates.

### QMK implementation

In `keymap.c`:

```c
layer_state_t layer_state_set_user(layer_state_t state) {
    return update_tri_layer_state(state, _NAV, _SYM, _NUM);
}
```

That's it — QMK's `update_tri_layer_state` handles the rest. When you release either thumb, NUM drops; the remaining held layer stays active.

---

## Tuning parameters (`config.h`)

```c
// --- Tap/hold timing ---
#define TAPPING_TERM 200
#define TAPPING_TERM_PER_KEY          // lets HRM keys have a different term
#define QUICK_TAP_TERM 175
#define QUICK_TAP_TERM_PER_KEY
#define PERMISSIVE_HOLD_PER_KEY        // HRM-specific
#define HOLD_ON_OTHER_KEY_PRESS_PER_KEY // opposite-hand trigger

// --- Idle guard: if you typed a key less than X ms ago, the next
//     tap-hold key on the same hand is forced to tap. Kills misfires
//     during fast rolls. ---
#define FLOW_TAP_TERM 150  // QMK 0.24+
// If you're on older QMK, use chordal_hold or custom process_record_user.

// --- Combo timing (tight to avoid accidental triggers) ---
#define COMBO_TERM 40
#define COMBO_MUST_HOLD_MODS
#define COMBO_ONLY_FROM_LAYER 0  // combos only active on base layer

// --- Caps-word ---
#define CAPS_WORD_INVERT_ON_SHIFT
#define CAPS_WORD_IDLE_TIMEOUT 3000

// --- Split-keyboard glue (Corne is split) ---
#define SPLIT_USB_DETECT
#define SPLIT_WATCHDOG_ENABLE
// #define MASTER_RIGHT  // uncomment if you use right-half-as-master

// --- Mouse-key accel curve (if you add mousekeys later) ---
// ...
```

### Per-key tuning stubs

```c
uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        // Home-row mods get a slightly longer term so fast typing doesn't
        // latch them as holds.
        case LGUI_T(KC_A):
        case RGUI_T(KC_SCLN):
            return 220;   // pinky — needs more time
        case LALT_T(KC_S):
        case LALT_T(KC_L):
            return 210;
        case LCTL_T(KC_D):
        case RCTL_T(KC_K):
        case LSFT_T(KC_F):
        case RSFT_T(KC_J):
            return 200;   // strong fingers — snappier
        default:
            return TAPPING_TERM;
    }
}

// Only let HRM resolve as hold when the NEXT key is on the other hand.
bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case LGUI_T(KC_A): case LALT_T(KC_S): case LCTL_T(KC_D): case LSFT_T(KC_F):
        case RSFT_T(KC_J): case RCTL_T(KC_K): case LALT_T(KC_L): case RGUI_T(KC_SCLN):
            return false;  // wait for next key release before deciding
        default:
            return true;
    }
}
```

---

## Features to enable (`rules.mk`)

```makefile
COMBO_ENABLE       = yes
CAPS_WORD_ENABLE   = yes
TAP_DANCE_ENABLE   = no   # not used; leave off for smaller firmware
MOUSEKEY_ENABLE    = no   # optional — add if you want mouse-on-keyboard
EXTRAKEY_ENABLE    = yes  # required for media keys (vol, play, etc.)
NKRO_ENABLE        = yes  # better for fast typing
LTO_ENABLE         = yes  # link-time optimization, smaller firmware
```

---

## Drop-in QMK `keymap.c`

```c
#include QMK_KEYBOARD_H

enum layers {
    _BASE,
    _NAV,
    _SYM,
    _NUM,
};

// Home-row mod aliases — keeps the grid readable.
#define HM_A  LGUI_T(KC_A)
#define HM_S  LALT_T(KC_S)
#define HM_D  LCTL_T(KC_D)
#define HM_F  LSFT_T(KC_F)
#define HM_J  RSFT_T(KC_J)
#define HM_K  RCTL_T(KC_K)
#define HM_L  LALT_T(KC_L)
#define HM_SC RGUI_T(KC_SCLN)

#define NAV_TAB LT(_NAV, KC_TAB)
#define SYM_BSP LT(_SYM, KC_BSPC)
#define ESC_CTL LCTL_T(KC_ESC)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

// -----------------------------------------------------------------------------
// BASE
// -----------------------------------------------------------------------------
[_BASE] = LAYOUT_split_3x6_3_ex2(
    KC_TAB,  KC_Q, KC_W, KC_E, KC_R, KC_T,                              KC_Y, KC_U, KC_I,    KC_O,   KC_P,    KC_BSPC,
    ESC_CTL, HM_A, HM_S, HM_D, HM_F, KC_G,                              KC_H, HM_J, HM_K,    HM_L,   HM_SC,   KC_QUOT,
    KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B,                              KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_ESC,
                          KC_LGUI, NAV_TAB, KC_SPC,                     KC_ENT, SYM_BSP, KC_RALT,
    // 4 inner extras: L-top, L-bot,  R-top,  R-bot
       KC_ESC, KC_TAB,                                                  KC_BSPC, KC_DEL
),

// -----------------------------------------------------------------------------
// NAV — arrows, page nav, clipboard
// -----------------------------------------------------------------------------
[_NAV] = LAYOUT_split_3x6_3_ex2(
    _______, _______, _______, _______, _______, _______,               KC_HOME,     KC_PGDN,     KC_PGUP,    KC_END,       KC_INS,  KC_DEL,
    _______, KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, _______,               KC_LEFT,     KC_DOWN,     KC_UP,      KC_RGHT,      KC_TAB,  KC_CAPS,
    _______, C(KC_Z), C(KC_X), C(KC_C), C(KC_V), C(KC_Y),               C(KC_LEFT),  C(KC_DOWN),  C(KC_UP),   C(KC_RGHT),   _______, _______,
                              _______, _______, _______,                _______, _______, _______,
       _______, _______,                                                _______, _______
),

// -----------------------------------------------------------------------------
// SYM — all programming symbols
// -----------------------------------------------------------------------------
[_SYM] = LAYOUT_split_3x6_3_ex2(
    _______, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,               KC_CIRC, KC_AMPR, KC_ASTR, KC_QUOT, KC_DQUO, KC_BSPC,
    _______, KC_EQL,  KC_MINS, KC_PLUS, KC_LCBR, KC_RCBR,               KC_PIPE, KC_SLSH, KC_BSLS, KC_LPRN, KC_RPRN, KC_GRV,
    _______, KC_TILD, KC_LT,   KC_GT,   KC_LBRC, KC_RBRC,               KC_QUES, KC_UNDS, KC_COLN, KC_SCLN, KC_COMM, KC_DOT,
                              _______, _______, _______,                _______, _______, _______,
       _______, _______,                                                _______, _______
),

// -----------------------------------------------------------------------------
// NUM — numpad, F-keys, media, reset (tri-layer: NAV+SYM)
// -----------------------------------------------------------------------------
[_NUM] = LAYOUT_split_3x6_3_ex2(
    KC_MUTE, KC_VOLD, KC_VOLU, KC_MPRV, KC_MPLY, KC_MNXT,               KC_PSLS, KC_P7, KC_P8, KC_P9, KC_PMNS, QK_RBT,
    _______, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                 KC_PAST, KC_P4, KC_P5, KC_P6, KC_PPLS, KC_EQL,
    QK_BOOT, KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,                KC_P0,   KC_P1, KC_P2, KC_P3, KC_PDOT, KC_UNDS,
                              _______, _______, _______,                _______, _______, _______,
       _______, _______,                                                _______, _______
),

};

// Tri-layer: hold NAV + SYM -> NUM
layer_state_t layer_state_set_user(layer_state_t state) {
    return update_tri_layer_state(state, _NAV, _SYM, _NUM);
}

// Combos
enum combos {
    FJ_CAPS,
    COMBO_LENGTH
};
uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM fj_combo[] = {HM_F, HM_J, COMBO_END};

combo_t key_combos[] = {
    [FJ_CAPS] = COMBO(fj_combo, CW_TOGG),
};
```

> **Note on `LAYOUT_split_3x6_3_ex2`** — this layout macro _must_ be defined in your Corne 4.1's `info.json` (or `corne.h`). If your firmware uses a different macro (e.g. `LAYOUT_corne_4_1`, `LAYOUT_46`), search your keyboard's `.h` file and substitute. The matrix order in the macro must match the physical key order in the map above:
>
> ```
> row 0 left (6) + row 0 right (6)
> row 1 left (6) + row 1 right (6)
> row 2 left (6) + row 2 right (6)
> thumbs left (3) + thumbs right (3)
> extras left (2) + extras right (2)     ← rightmost 4
> ```

---

## Importing the JSON into config.qmk.fm

The companion file `corne-qmk-keymap.json` in this repo is ready to import:

1. Open https://config.qmk.fm
2. Hit the **load** icon → pick `corne-qmk-keymap.json`
3. Verify `keyboard` resolves — it's set to `crkbd/rev4_1` with layout `LAYOUT_split_3x6_3_ex2`. **If the Configurator rejects either**, it's because mainline QMK doesn't expose a matching rev/layout for the 46-key Corne 4.1 (foostan's 4.1 ships with only 42-key official support in some forks). Two fallbacks:
   - **(a)** Change `keyboard` to whatever 46-key rev your firmware fork uses (common names: `crkbd/rev4`, `crkbd/v4_1`, `crkbd_46`) and `layout` to that rev's matching layout macro — search your fork's `keyboard.json` / `info.json`.
   - **(b)** Drop to 42-key: set `keyboard` = `crkbd/rev1`, `layout` = `LAYOUT_split_3x6_3`, and delete the last 4 keycodes from each layer (the inner-column extras). You'll lose the OLED-replacement keys in software, but the core keymap still works.
4. Compile in the Configurator → download `.hex` / `.uf2`
5. Flash with QMK Toolbox

### Key order in the 46-key JSON

Each layer array is 46 keycodes in this order:

```
rows 0–2 (36 keys) : left-6 then right-6 per row, same as 42-key
thumbs (6 keys)    : L-outer, L-mid, L-inner, R-inner, R-mid, R-outer
extras (4 keys)    : L-top, L-bot, R-top, R-bot    ← appended at the end
```

So positions 42 and 43 are the left inner extras; 44 and 45 are the right.

### What the Configurator can't do (post-export work on `keymap.c`)

Three things require editing the generated `keymap.c` after the Configurator produces it:

1. **Tri-layer (NAV+SYM → NUM)** — without this, layer 3 is unreachable:
   ```c
   layer_state_t layer_state_set_user(layer_state_t state) {
       return update_tri_layer_state(state, 1, 2, 3);
   }
   ```
2. **F+J combo → `CAPS_WORD`** — set `COMBO_ENABLE = yes` and `CAPS_WORD_ENABLE = yes` in `rules.mk`, then define the combo (template in the `keymap.c` section above).
3. **Per-key HRM tuning** (`get_tapping_term`, `get_hold_on_other_key_press`) — these control misfire prevention and live in `keymap.c`.

---

## Learning curve — first week plan

1. **Day 1–2** — Type normally. Ignore HRM; if it fires a mod accidentally, just correct and move on. Learn where the layers are. Get used to the left-thumb Nav + right-thumb Sym split.
2. **Day 3–4** — Start deliberately using HRM for `Shift+letter` (the easiest case). Type `Hello` as `hold-F, press-H, release-F, press-ello`. Feels weird; will click by Day 5.
3. **Day 5–7** — Start using `<C-*>` via HRM-D/K. Try `<C-d>` and `<C-u>` in vim. Try `Ctrl-W` closing a tab.
4. **Week 2** — Adopt the Sym layer for programming. Uninstall your old keymap from the other computer so you can't fall back.
5. **Week 3** — Add optional combos (`Q+W` → Esc, etc.) if you want them.

### When it's going wrong

| Symptom                                               | Tune                                                                              |
| ----------------------------------------------------- | --------------------------------------------------------------------------------- |
| HRM mod fires when you're just typing fast            | Raise `TAPPING_TERM` to 220; raise `FLOW_TAP_TERM` to 175                         |
| Have to hold too long to get a mod                    | Lower `TAPPING_TERM` to 180                                                       |
| Fast same-key rolls (`aa`, `ss`) drop a letter        | Lower `QUICK_TAP_TERM` to 150                                                     |
| Accidentally capsword from rolling fingers            | Raise `COMBO_TERM` to 50 but watch for other combo misfires                       |
| `SPACE` as leader fires but next key doesn't register | Not an HRM issue — check you're not holding Space while the leader sequence fires |
