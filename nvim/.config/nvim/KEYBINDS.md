# Keybinds

Every mapping this config defines.

Leader is `<Space>`, so `<leader>ff` means Space, then `f`, then `f`.

Mode column: n normal, i insert, v/x visual, s select.

Rows marked (LSP) only work in buffers with a language server attached: Java,
Kotlin, Rust, TypeScript, Lua, C/C++, Python, JSON, CSS.

Mappings live in `lua/config/keybinds.lua` unless a section says otherwise.

## Files and buffers

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
| `<leader>o` | n | Save and re-source the current file |

Pickers are from `lua/plugins/telescope.lua`. Inside one: `<C-n>` and `<C-p>`
move, `<CR>` opens, `<C-x>` and `<C-v>` open in a split, `<C-q>` sends all
results to the quickfix list, `<C-c>` closes. `<Esc>` does not close a picker
on the first press; it drops to normal mode inside the picker first.

## Harpoon

A short pinned list of files you are working between. From
`lua/plugins/harpoon.lua`.

| Key | Mode | Action |
|---|---|---|
| `<leader>a` | n | Add current file to the list |
| `<leader>ar` | n | Remove current file from the list |
| `<C-e>` | n | Toggle the quick menu (edit as text, then `:w`) |
| `<leader>fl` | n | Browse the list in Telescope with preview |
| `<C-n>` | n | Next file in the list |
| `<C-p>` | n | Previous file in the list |

## Code navigation (LSP)

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gr` | n | List references |
| `gO` | n | Document symbols (outline of this file) |
| `<leader>fs` | n | Workspace symbols (search symbols project-wide) |
| `<leader>ci` | n | Incoming calls (what calls this) |
| `<leader>co` | n | Outgoing calls (what this calls) |

Multiple results open a Telescope picker with preview. Jump back with `<C-o>`,
forward with `<C-i>`.

## Documentation (LSP)

| Key | Mode | Action |
|---|---|---|
| `K` | n | Hover docs for the symbol under the cursor |
| `gs` | n | Signature help |
| `<C-s>` | i | Signature help without leaving insert mode |

Press `K` twice to move into the hover window and scroll it. `q` closes it.

## Refactoring (LSP)

| Key | Mode | Action |
|---|---|---|
| `<leader>rn` | n | Rename symbol everywhere |
| `<leader>ca` | n, x | Code action (quick fixes, imports, generate) |
| `<leader>cl` | n | Run the code lens on this line |

## Diagnostics (LSP)

| Key | Mode | Action |
|---|---|---|
| `]d` / `[d` | n | Next / previous diagnostic |
| `]e` / `[e` | n | Next / previous error, skipping warnings and hints |
| `<leader>ll` | n | Show all diagnostics for the current line |
| `<leader>lq` | n | List diagnostics across all open buffers |
| `<leader>lh` | n | Toggle inlay hints |

Current-line diagnostics also appear on their own after 250ms of holding still,
set by `updatetime` in `lua/config/options.lua`.

Inlay hints are the greyed-in parameter names and inferred types such as
`first:` and `: int`. They are on by default.

## Formatting

| Key | Mode | Action |
|---|---|---|
| `<leader>F` | n, x | Format buffer, or the selection in visual mode |

Capital `F`, because lowercase `f` is taken by the find pickers. Routing is in
`lua/plugins/format.lua`: Prettier for web files, `google-java-format` for Java,
`ktlint` for Kotlin, and the language server's own formatter otherwise.

## Java only

In `.java` buffers, from `lua/plugins/java.lua`. Code navigation and
refactoring above work here too.

| Key | Mode | Action |
|---|---|---|
| `<leader>ji` | n | Organize imports |
| `<leader>jv` | n | Extract the expression under the cursor to a variable |
| `<leader>jc` | n | Extract the expression under the cursor to a constant |
| `<leader>jm` | v | Extract the selected lines to a method |

## Completion

The popup appears as you type. From `lua/plugins/completion.lua`.

| Key | Mode | Action |
|---|---|---|
| `<Tab>` / `<S-Tab>` | i, s | Next / previous item |
| `<C-n>` / `<C-p>` | i | Next / previous item |
| `<CR>` | i | Accept the selected item |
| `<C-Space>` | i | Trigger completion manually |
| `<C-e>` | i | Dismiss the popup |
| `<C-f>` / `<C-u>` | i | Scroll the documentation window down / up |

The first match is highlighted automatically, so `<CR>` accepts it even if you
never pressed `<Tab>`. Press `<C-e>` first if you want a plain newline.

## Clipboard

| Key | Mode | Action |
|---|---|---|
| `<leader>y` | n, x | Yank to the system clipboard |
| `<leader>d` | n, x | Delete to the system clipboard |

Plain `y` and `d` use Vim's own registers, so copying inside Neovim does not
overwrite the system clipboard.

## Differences from stock Neovim

`gi` is remapped. It normally jumps to the last insert position; here it goes to
implementation. `gI` is untouched.

Neovim's default `gr` maps are removed (`grn`, `gra`, `grr`, `gri`, `grt`,
`grx`). Keeping them would make a bare `gr` wait to see if another key follows.
`gr`, `<leader>rn`, `<leader>ca`, `gi`, `gy` and `<leader>cl` replace them.

`<leader>d` is delete-to-clipboard, not diagnostics. Diagnostics are under
`<leader>l` for that reason.

`<C-n>` and `<C-p>` are Harpoon in normal mode and completion in insert mode.
They do not collide.

## Prefixes

| Prefix | Means |
|---|---|
| `g` | Go somewhere: definition, references, implementation |
| `[` `]` | Previous / next |
| `<leader>f` | Find |
| `<leader>c` | Code: actions, lenses, call hierarchy |
| `<leader>l` | Lists and diagnostics |
| `<leader>j` | Java only |

## Adding your own

General mappings go in `lua/config/keybinds.lua`. Mappings that should only
exist where a language server is running go in the `LspAttach` block in that
same file. Plugin-specific ones go with their plugin under `lua/plugins/`.

Run `:verbose nmap <key>` to see what a key is bound to and which file set it.
