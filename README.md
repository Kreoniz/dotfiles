# Dotfiles

GNU Stow manages these dotfiles as packages. Each top-level directory is a
package, and its contents are laid out relative to `$HOME`.

## Layout

```text
bash/.bashrc
tmux/.tmux.conf
alacritty/.config/alacritty/alacritty.toml
kitty/.config/kitty/kitty.conf
nvim/.config/nvim/init.lua
```

This makes it possible to install everything, or only the packages needed on a
specific machine.

## Install

From the repository root:

```sh
stow -nv -t "$HOME" bash tmux alacritty kitty nvim
stow -v -t "$HOME" bash tmux alacritty kitty nvim
```

The first command is a dry run. Run the second command only after the dry run
looks correct.

## Install One Package

```sh
stow -nv -t "$HOME" nvim
stow -v -t "$HOME" nvim
```

## Remove Symlinks

```sh
stow -D -t "$HOME" bash tmux alacritty kitty nvim
```

## Conflicts

If Stow reports a conflict, there is already a real file or directory at the
target path in `$HOME`. Move it out of the way first, then run Stow again.

Example:

```sh
mv ~/.bashrc ~/.bashrc.backup
stow -v -t "$HOME" bash
```

Avoid `--adopt` unless you specifically want Stow to move existing files from
`$HOME` into this repository. If you use it, check `git diff` immediately after.
