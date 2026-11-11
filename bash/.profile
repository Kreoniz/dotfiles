# Environment for POSIX login shells; Bash uses .bash_profile instead.
if [ -r "$HOME/.config/bash/env.sh" ]; then
    . "$HOME/.config/bash/env.sh"
fi
if [ -r "$HOME/.config/vite-plus/env" ]; then
    . "$HOME/.config/vite-plus/env"
fi
