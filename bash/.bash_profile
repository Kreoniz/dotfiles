# Bash login shells share the same setup as terminal shells.
if [ -r "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
