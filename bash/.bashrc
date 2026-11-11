# Fedora supplies history, completion, and terminal-title integration.
[[ ! -r /etc/bashrc ]] || . /etc/bashrc

# Bootstrap mise, then retain the existing local-tool and Vite+ precedence.
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi
[[ ! -r "$HOME/.config/bash/env.sh" ]] || . "$HOME/.config/bash/env.sh"
[[ ! -r "$HOME/.config/vite-plus/env" ]] || . "$HOME/.config/vite-plus/env"

# Personal extensions remain supported.
if [[ -d "$HOME/.bashrc.d" ]]; then
    for rc in "$HOME"/.bashrc.d/*; do
        [[ ! -f "$rc" ]] || . "$rc"
    done
    unset rc
fi
[[ ! -r "$HOME/.config/bash/helpers.bash" ]] || . "$HOME/.config/bash/helpers.bash"
alias rm='rm -i'

__prompt_update() {
    local previous_status=$? ref env_name
    case "$PWD" in
        "$HOME") __prompt_path='~' ;;
        "$HOME"/*) __prompt_path="~/${PWD#"$HOME"/}" ;;
        *) __prompt_path=$PWD ;;
    esac
    __prompt_git=
    if ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); then
        __prompt_git=" ($ref)"
    fi
    env_name=${VIRTUAL_ENV##*/}
    env_name=${env_name:-${CONDA_DEFAULT_ENV:-${PYENV_VERSION:-}}}
    __prompt_python=${env_name:+ ($env_name)}
    return "$previous_status"
}

if [[ $- == *i* ]]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    # Expand variables at display time; never evaluate branch names as shell code.
    PS1='\[\e[32m\]${__prompt_path}\[\e[36m\]${__prompt_git}\[\e[33m\]${__prompt_python}\[\e[0m\] '
    if [[ ${PROMPT_COMMAND@a} == *a* ]]; then
        if [[ " ${PROMPT_COMMAND[*]} " != *' __prompt_update '* ]]; then
            PROMPT_COMMAND+=(__prompt_update)
        fi
    elif [[ ";${PROMPT_COMMAND:-};" != *';__prompt_update;'* ]]; then
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}__prompt_update"
    fi
    complete -o filenames -o nospace -F _cdw_complete cdw
fi
[[ ! -r "$HOME/.bashrc.local" ]] || . "$HOME/.bashrc.local"
