# Keybinds

Every mapping this config defines, grouped by what you're trying to do.

**Leader is `<Space>`.** So `<leader>ff` means: tap Space, then `f`, then `f`.

Mode column: **n** normal · **i** insert · **v/x** visual · **s** select.
Mappings marked *(LSP)* only exist in buffers with a language server attached —
Java, Kotlin, Rust, TypeScript, Lua, C/C++, Python, JSON, CSS.

Defined in [`lua/config/keybinds.lua`](lua/config/keybinds.lua) unless noted.

---

## Files & buffers

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep (search file contents) |
| `<leader>fb` | n | Switch buffer |
| `<leader>fh` | n | Search help |
| `<leader>cd` | n | Open netrw file explorer |
| `<leader>w` | n | Write |
| `<leader>q` | n | Quit |
| `<leader>e` | n | Reload file from disk |
| `<leader>o` | n | Save and re-source the current file (for editing this config live) |

The `f` pickers come from [`lua/plugins/telescope.lua`](lua/plugins/telescope.lua).
Inside a picker: `<C-n>`/`<C-p>` move, `<CR>` opens, `<C-x>`/`<C-v>` open in a
horizontal/vertical split, `<C-q>` sends every result to the quickfix list.
Pickers start in insert mode — `<C-c>` closes one outright, while `<Esc>` first
drops you to normal mode inside the picker and only closes on a second press.

## Harpoon — pinned working set

Harpoon is a short, manually curated list of the files you're actively moving
between. Pin a file once, then jump without searching.
From [`lua/plugins/harpoon.lua`](lua/plugins/harpoon.lua).

| Key | Mode | Action |
|---|---|---|
| `<leader>a` | n | Add current file to the list |
| `<leader>ar` | n | Remove current file from the list |
| `<C-e>` | n | Toggle the quick menu (edit the list as text, then `:w`) |
| `<leader>fl` | n | Browse the list in Telescope, with preview |
| `<C-n>` | n | Next file in the list |
| `<C-p>` | n | Previous file in the list |

## Code navigation *(LSP)*

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gr` | n | List references |
| `gO` | n | Document symbols (outline of this file) |
| `<leader>fs` | n | Workspace symbols (search symbols project-wide) |
| `<leader>ci` | n | Incoming calls (who calls this?) |
| `<leader>co` | n | Outgoing calls (what does this call?) |

When a symbol has more than one result these open a Telescope picker with a
preview, which is the normal case in Java and Kotlin — interfaces, overloads
and overrides. Jump back with `<C-o>`, forward again with `<C-i>`.

## Documentation *(LSP)*

| Key | Mode | Action |
|---|---|---|
| `K` | n | Hover docs for the symbol under the cursor |
| `gs` | n | Signature help |
| `<C-s>` | i | Signature help, without leaving insert mode |

Press `K` twice to move the cursor *into* the hover window so you can scroll it;
`q` closes it.

## Refactoring & fixes *(LSP)*

| Key | Mode | Action |
|---|---|---|
| `<leader>rn` | n | Rename symbol everywhere |
| `<leader>ca` | n, x | Code action — quick fixes, imports, generate |
| `<leader>cl` | n | Run the code lens on this line |

`<leader>ca` is the workhorse: it offers "import this class", "implement
missing methods", "generate getters", and every diagnostic quick-fix.

## Diagnostics — errors & warnings *(LSP)*

| Key | Mode | Action |
|---|---|---|
| `]d` / `[d` | n | Next / previous diagnostic |
| `]e` / `[e` | n | Next / previous **error**, skipping warnings and hints |
| `<leader>ll` | n | Show all diagnostics for the current line |
| `<leader>lq` | n | List diagnostics across all open buffers |
| `<leader>lh` | n | Toggle inlay hints |

Diagnostics for the current line also pop up on their own after 250ms of
holding still — that's `updatetime` in [`lua/config/options.lua`](lua/config/options.lua).

Inlay hints are the greyed-in parameter names and inferred types (`first:`,
`: int`) that aren't really in the file. They're on by default.

## Formatting

| Key | Mode | Action |
|---|---|---|
| `<leader>F` | n, x | Format buffer, or just the selection in visual mode |

Capital `F` — lowercase `f` is taken by the find pickers. Routing lives in
[`lua/plugins/format.lua`](lua/plugins/format.lua): Prettier for web files,
`google-java-format` for Java, `ktlint` for Kotlin, and the language server's
own formatter for anything else.

## Java-specific

Only in `.java` buffers, from [`lua/plugins/java.lua`](lua/plugins/java.lua).
Everything under *Code navigation* and *Refactoring* works here too.

| Key | Mode | Action |
|---|---|---|
| `<leader>ji` | n | Organize imports |
| `<leader>jv` | n | Extract the expression under the cursor to a variable |
| `<leader>jc` | n | Extract the expression under the cursor to a constant |
| `<leader>jm` | v | Extract the selected lines to a method |

## Completion (insert mode)

The popup appears as you type. From [`lua/plugins/completion.lua`](lua/plugins/completion.lua).

| Key | Mode | Action |
|---|---|---|
| `<Tab>` / `<S-Tab>` | i, s | Next / previous item |
| `<C-n>` / `<C-p>` | i | Next / previous item |
| `<CR>` | i | Accept the selected item |
| `<C-Space>` | i | Trigger completion manually |
| `<C-e>` | i | Dismiss the popup |
| `<C-f>` / `<C-u>` | i | Scroll the documentation window down / up |

The first match is highlighted automatically, so `<CR>` accepts it even if you
never pressed `<Tab>`. Press `<C-e>` first when you want a plain newline.

## Clipboard

| Key | Mode | Action |
|---|---|---|
| `<leader>y` | n, x | Yank to the **system** clipboard |
| `<leader>d` | n, x | Delete to the **system** clipboard |

Plain `y` and `d` stay in Vim's own registers, so copying inside Neovim never
clobbers what you copied from the browser.

---

## Notes for anyone coming from stock Neovim

- **`gi` is remapped.** It normally jumps to your last insert position; here it
  goes to implementation, which is the IDE convention. `gI` (insert at column 1)
  is untouched.
- **Neovim's default `gr` maps are removed.** Neovim 0.11+ ships `grn`, `gra`,
  `grr`, `gri`, `grt` and `grx`. Keeping them would make a bare `gr` sit and
  wait to see whether another key follows. They're gone; `gr`, `<leader>rn`,
  `<leader>ca`, `gi`, `gy` and `<leader>cl` replace them one for one.
- **`<leader>d` is delete-to-clipboard, not diagnostics.** Diagnostic mappings
  live under `<leader>l` for that reason.
- **`<C-n>`/`<C-p>` do double duty** — Harpoon navigation in normal mode,
  completion navigation in insert mode. They never collide.

## Conventions

Once you've noticed these, most of the map is guessable:

| Prefix | Means |
|---|---|
| `g` | **g**o somewhere — definition, references, implementation |
| `[` `]` | previous / next of something |
| `<leader>f` | **f**ind |
| `<leader>c` | **c**ode — actions, lenses, call hierarchy |
| `<leader>l` | **l**ist / diagnostics |
| `<leader>j` | **J**ava-only |

## Adding your own

General mappings go in [`lua/config/keybinds.lua`](lua/config/keybinds.lua).
Ones that should only exist where a language server is running go inside the
`LspAttach` block in that same file. Plugin-specific ones live with their
plugin under `lua/plugins/`.

To check what a key is currently bound to, use `:verbose nmap <key>` — it
reports both the mapping and the file that set it.
