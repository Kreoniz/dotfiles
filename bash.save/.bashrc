# Source global definitions (do this first as it may affect PATH)
[ -f /etc/bashrc ] && . /etc/bashrc

# Set PATH efficiently in one operation
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Shell options
shopt -s checkwinsize  # Update window size after each command
shopt -s globstar 2>/dev/null  # Enable ** recursive globbing

# Fast git branch detection for prompt
parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/^* \(.*\)/(\1)/p'
}

# Set PS1 (prompt) - keep this simple for speed
PS1='\[\e[0;38;5;46m\]\u@\H\[\e[0m\]:\[\e[0;38;5;51m\]\w \[\e[0;38;5;202m\]$(parse_git_branch)\[\e[0m\]\$ '

# Core aliases
alias ls='ls --color=auto'
alias rm='rm -i'
alias upd='sudo dnf check-update --refresh && sudo dnf upgrade -y && flatpak update'

# Git shortcuts
alias gl='git log --oneline'
alias ggc='git log --oneline --graph'
alias gg='git log --oneline --graph --all'

# NVM - only load when needed
export NVM_DIR="$HOME/.nvm"
nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Angular CLI
ng() {
    unset -f ng
    source <(ng completion script)
    ng "$@"
}

# thefuck
fuck() {
    unset -f fuck
    eval "$(thefuck --alias)"
    fuck "$@"
}
alias damn='fuck'

export EDITOR='nvim'
export NVIMCONF="$HOME/.config/nvim"

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$BUN_INSTALL/bin:$PNPM_HOME:$PATH:/usr/local/go/bin"

export QT_QPA_PLATFORMTHEME=qt5ct
export TERM="tmux-256color"

# Load remaining aliases if file exists
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Load bash completions
[ -d ~/.bashrc.d ] && for rc in ~/.bashrc.d/*; do [ -f "$rc" ] && . "$rc"; done

# Cargo environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ghcup environment
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"


# Clean up
unset rc

# Optional: If using Wayland with VSCode
[ "$XDG_SESSION_TYPE" = "wayland" ] && alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland"

# Compiler flags
alias Wg++="g++ -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror -std=c++23"
