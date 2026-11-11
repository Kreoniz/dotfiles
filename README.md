# Dotfiles

GNU Stow manages these dotfiles as packages. Each top-level directory is a
package, and its contents are laid out relative to `$HOME`.

## Layout

```text
bash/.bashrc
bash/.bash_profile
bash/.profile
bash/.config/bash/
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

## Bash

Bash 4.4+ login and terminal shells share `.bashrc`. Shared environment setup is in
`bash/.config/bash/env.sh`; helper functions are in `helpers.bash`. The managed
`.profile` also provides the environment to POSIX login shells.

Mise activation, Cargo, pnpm, Wine, OpenCode, and Vite+ remain available. Vite+
keeps its existing Node/pnpm precedence, shell wrapper, and completions. Optional
setup files are loaded only when present. PATH entries and prompt hooks are not
duplicated when re-sourcing the config. Git branches (including detached HEAD)
and Python virtual environments are updated on every prompt.

- `gg`: decorated Git history graph across all branches.
- `cdw [project]`: open a project below `~/code`, with directory completion.
  Set `WORK_DIR` to use another project root.
- `icat file`: display an image in Kitty.
- `pngdiff [git-ref] file.png`: show the Git version, current image, and visual diff.
- `pngdiffs [git-ref]`: show staged, unstaged, deleted, and untracked PNG changes.
- `imgdiff` / `gimgdiff` and their plural forms are aliases for the PNG helpers.

Image comparisons use Git, ImageMagick, and Kitty. LFS-backed snapshots also
require Git LFS. Preview files use the on-disk user cache and are cleaned up after
each call. Existing `~/.bashrc.d/*` files are still loaded; `~/.bashrc.local` can
hold machine-specific overrides.

The `bash` package now also owns `.bash_profile`, `.profile`, and `.config/bash`.
When installing on a machine with existing real files, back them up before Stow.
