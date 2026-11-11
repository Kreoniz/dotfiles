# Neovim

Personal config for Neovim 0.11.3 or newer, managed with lazy.nvim.

## Layout

- `init.lua`: load options, keymaps, and plugins.
- `lua/config/`: editor settings, basic mappings, plugin bootstrap, and TypeScript server selection.
- `lua/plugins/editor.lua`: theme, statusline, Git signs, text objects, surround, and color previews.
- `lua/plugins/search.lua`: Telescope and search shortcuts.
- `lua/plugins/lsp.lua`: enabled language servers and code navigation.
- `lua/plugins/completion.lua`: completion and snippets.
- `lua/plugins/formatting.lua`: formatters and format-on-save behavior.
- `lua/plugins/treesitter.lua`: syntax parsers, highlighting, and indentation.

`lazy-lock.json` records the plugin revisions. Use `:Lazy restore` to restore
those revisions and `:Lazy update` to intentionally update them.

## Setup

Install Neovim, Git, ripgrep, make, a C compiler, and mise. Select a Nerd Font
in the terminal. Runtime tools use mise; language servers and StyLua use Mason.

Install the pinned TypeScript server:

```sh
mise install npm:tsc-rs@0.8.0
```

Neovim runs it with `mise exec`, so global activation is unnecessary. On a new
machine, open Neovim and allow Mason and Tree-sitter to finish installing tools.
The Java server uses `mise exec java@openjdk-27` independently of project Java versions.

## Search and editing

Space is the leader key. Telescope's internal picker controls use their existing defaults.

| Shortcut | Action |
| --- | --- |
| Space ff | Find files |
| Space fg | Search project text |
| Space fb | Open buffers |
| Space fw | Search word under cursor |
| Space fr | Recent files |
| Space fh | Help |
| Space fk | Keymaps |
| Space fF | Include hidden files |
| Space fR | Resume last search |
| Space fd | Diagnostics |
| Space fn | Neovim config files |
| Space fs | Choose a Telescope picker |
| Space f/ | Search open files |
| Space / | Search current buffer |
| Space cf | Format buffer or selection |
| Ctrl-h/j/k/l | Move between windows |
| - | Open netrw |
| gd / gr / gI / gD | Definition / references / implementation / declaration |
| Space D | Type definition |
| Space ds / ws | Document / workspace symbols |
| Space rn / ca | Rename / code action |
| Space th | Toggle inlay hints when supported |
| Space q | Buffer diagnostics list |

Completion uses Ctrl-n/p to select, Ctrl-y to accept, Ctrl-Space to trigger,
Ctrl-b/f to scroll documentation, and Ctrl-l/h to navigate snippets.

Formatting on save remains enabled, using project-local Prettier/prettierd for
web files and StyLua for Lua. The LSP is a fallback except for C and C++.

## TypeScript

Ordinary JavaScript, TypeScript, JSX, and TSX projects use
[ts-rust](https://github.com/pingdotgg/ts-rust), registered as `ts_rust` in Neovim.
It runs the native LSP with `--lsp --stdio`; no tsserver wrapper is involved.

A workspace-root `node_modules/.bin/tsc-rs` takes priority over the mise-managed
0.8.0 installation. To pin it for a project, install it at the workspace root:

```sh
pnpm add -D tsc-rs@0.8.0
```

Vue/Nuxt projects use `ts_ls` with the Vue plugin and `vue_ls`. Selection checks
the closest package.json and workspace-root package.json for Vue/Nuxt dependencies;
`.vue` files always use this integration. The TypeScript servers are mutually
exclusive for each buffer. Deno projects are left to their own tooling.

The Rust port is experimental. This editor configuration does not replace any
project's TypeScript dependency or change its build/type-check commands.

Version 0.8.0 currently exits with code 1 and `context canceled` even after a
normal LSP shutdown. Neovim can display a server-exit warning when stopping it.
Editing requests passed validation; the shutdown behavior also has an
[upstream native TypeScript report](https://github.com/microsoft/TypeScript/issues/64742).

## Troubleshooting

- `:checkhealth vim.lsp` shows attached servers and their commands.
- `:Mason` manages language servers; `:MasonToolsInstall` installs the configured list.
- `:ConformInfo` shows available formatters.
- `:Lazy` manages plugins.

The config is derived from kickstart.nvim; its original license is retained in `LICENSE.md`.
