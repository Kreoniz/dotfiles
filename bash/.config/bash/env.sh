# Shared by Bash and POSIX login shells.
export EDITOR=nvim VISUAL=nvim GIT_EDITOR=nvim
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

__shell_add_path() {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}
__shell_add_path "$HOME/bin"
__shell_add_path "$PNPM_HOME"
[ ! -r "$HOME/.cargo/env" ] || . "$HOME/.cargo/env"
__shell_add_path "$PNPM_HOME/bin"
unset -f __shell_add_path

# Keep existing tool priority and retain inherited entries, without duplicates.
__shell_path="$HOME/.opencode/bin:$HOME/apps/wine/wine-11.18-staging-amd64/bin:$HOME/.local/bin:$PATH"
__shell_seen=:
__shell_new=
__shell_separator=
while :; do
    __shell_dir=${__shell_path%%:*}
    case "$__shell_seen" in
        *:"$__shell_dir":*) ;;
        *)
            __shell_new=$__shell_new$__shell_separator$__shell_dir
            __shell_separator=:
            __shell_seen=$__shell_seen$__shell_dir:
            ;;
    esac
    case "$__shell_path" in
        *:*) __shell_path=${__shell_path#*:} ;;
        *) break ;;
    esac
done
export PATH=$__shell_new
unset __shell_path __shell_seen __shell_new __shell_separator __shell_dir
