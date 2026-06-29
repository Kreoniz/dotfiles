# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR='nvim'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

__prompt_dir() {
    case "$PWD" in
        "$HOME")
            printf '~'
            ;;
        "$HOME"/*)
            printf '~/%s' "${PWD#"$HOME"/}"
            ;;
        *)
            printf '%s' "$PWD"
            ;;
    esac
}

__prompt_git_suffix() {
    local ref

    ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
    [ -n "$ref" ] && printf ' (%s)' "$ref"
}

__prompt_python_suffix() {
    local env_name

    if [ -n "$VIRTUAL_ENV" ]; then
        env_name=${VIRTUAL_ENV##*/}
    elif [ -n "$CONDA_DEFAULT_ENV" ]; then
        env_name=$CONDA_DEFAULT_ENV
    elif [ -n "$PYENV_VERSION" ]; then
        env_name=$PYENV_VERSION
    fi

    [ -n "$env_name" ] && printf ' (%s)' "$env_name"
}

__prompt_color() {
    case "$1" in
        black) printf '\\[\\e[30m\\]' ;;
        red) printf '\\[\\e[31m\\]' ;;
        green) printf '\\[\\e[32m\\]' ;;
        yellow) printf '\\[\\e[33m\\]' ;;
        blue) printf '\\[\\e[34m\\]' ;;
        magenta) printf '\\[\\e[35m\\]' ;;
        cyan) printf '\\[\\e[36m\\]' ;;
        white) printf '\\[\\e[37m\\]' ;;
        reset) printf '\\[\\e[0m\\]' ;;
    esac
}

if [[ $- == *i* ]]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    prompt_path_color=$(__prompt_color green)
    prompt_git_color=$(__prompt_color cyan)
    prompt_python_color=$(__prompt_color yellow)
    prompt_reset=$(__prompt_color reset)

    PS1="${prompt_path_color}"'$(__prompt_dir)'"${prompt_git_color}"'$(__prompt_git_suffix)'"${prompt_python_color}"'$(__prompt_python_suffix)'"${prompt_reset}"' '
fi

alias rm='rm -i'

# fnm
FNM_PATH="/home/kreoniz/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell bash)"
fi
