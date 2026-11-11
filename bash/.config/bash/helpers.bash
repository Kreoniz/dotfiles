alias gg='git log --all --oneline --graph --decorate'

# Override WORK_DIR for a different project root.
cdw() {
    if (( $# > 1 )); then
        printf 'usage: cdw [project]\n' >&2
        return 2
    fi
    cd -- "${WORK_DIR:-$HOME/code}/${1:-}"
}

_cdw_complete() {
    local root=${WORK_DIR:-$HOME/code} directory
    root=${root%/}
    COMPREPLY=()
    while IFS= read -r directory; do
        COMPREPLY+=("${directory#"$root/"}/")
    done < <(compgen -d -- "$root/${COMP_WORDS[COMP_CWORD]}")
}

icat() {
    command kitty +kitten icat --transfer-mode=file "$@"
}

_pngdiff_read_git_image() {
    local commit=$1 file=$2 target=$3 first_line
    command git show "$commit:$file" > "$target" || return
    IFS= read -r first_line < "$target"
    if [[ $first_line == 'version https://git-lfs.github.com/spec/v1' ]]; then
        if ! command -v git-lfs >/dev/null 2>&1; then
            printf 'Git LFS is required to read this snapshot: %s\n' "$file" >&2
            return 1
        fi
        command git lfs smudge -- "$file" < "$target" > "$target.lfs" || return
        command mv -- "$target.lfs" "$target" || return
    fi
}

# A subshell keeps cwd and cleanup traps local to each invocation.
pngdiff() (
    if (( $# < 1 || $# > 2 )); then
        printf 'usage: pngdiff [git-ref] path/to/image.png\n' >&2
        return 2
    fi
    local base=HEAD file=$1 root commit tmp cache result
    if (( $# == 2 )); then
        base=$1
        file=$2
    fi
    root=$(git rev-parse --show-toplevel) || return
    commit=$(git rev-parse --verify --quiet --end-of-options "$base^{commit}") || {
        printf 'Unknown Git ref: %s\n' "$base" >&2
        return 2
    }
    file=$(realpath -m --relative-to="$root" -- "$file") || return
    if [[ $file == .. || $file == ../* ]]; then
        printf 'Image is outside this repository: %s\n' "$file" >&2
        return 2
    fi
    cd -- "$root" || return
    cache=${XDG_CACHE_HOME:-$HOME/.cache}/pngdiff
    command mkdir -p -- "$cache" || return
    tmp=$(mktemp -d "$cache/preview.XXXXXXXX") || return
    trap 'command rm -rf -- "$tmp"' EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM

    if ! git cat-file -e "$commit:$file" 2>/dev/null; then
        if [[ ! -f $file ]]; then
            printf 'Image not found: %s\n' "$file" >&2
            return 1
        fi
        printf '%s: new image relative to %s\n' "$file" "$base"
        icat "$file"
        return
    fi
    _pngdiff_read_git_image "$commit" "$file" "$tmp/old.png" || return
    if [[ ! -f $file ]]; then
        printf '%s: deleted image at %s\n' "$file" "$base"
        icat "$tmp/old.png"
        return
    fi
    if ! command -v magick >/dev/null 2>&1; then
        printf 'ImageMagick is required for comparison; showing the current image.\n' >&2
        icat "$file"
        return 1
    fi
    command cp -- "$file" "$tmp/new.png" || return
    if command magick compare -metric AE "$tmp/old.png" "$tmp/new.png" "$tmp/diff.png" 2>/dev/null; then
        result=0
    else
        result=$?
    fi
    if (( result > 1 )); then
        printf 'Could not compare image: %s\n' "$file" >&2
        return "$result"
    fi
    command magick "$tmp/old.png" "$tmp/new.png" "$tmp/diff.png" +append "$tmp/preview.png" || return
    printf '%s: %s | current | diff\n' "$file" "$base"
    icat "$tmp/preview.png"
)

pngdiffs() (
    if (( $# > 1 )); then
        printf 'usage: pngdiffs [git-ref]\n' >&2
        return 2
    fi
    local base=${1:-HEAD} root commit file result=0
    local -a files
    root=$(git rev-parse --show-toplevel) || return
    commit=$(git rev-parse --verify --quiet --end-of-options "$base^{commit}") || {
        printf 'Unknown Git ref: %s\n' "$base" >&2
        return 2
    }
    cd -- "$root" || return
    # NUL delimiters also handle spaces and newlines in filenames.
    mapfile -d '' -t files < <(
        {
            git -c filter.lfs.clean=cat -c filter.lfs.process= -c filter.lfs.required=false \
                diff --name-only --no-ext-diff --no-renames -z "$commit" -- '*.png'
            git ls-files --others --exclude-standard -z -- '*.png'
        } | sort -zu
    )
    if (( ${#files[@]} == 0 )); then
        printf 'No changed PNG files relative to %s.\n' "$base"
        return
    fi
    for file in "${files[@]}"; do
        pngdiff "$base" "$file" || result=1
    done
    return "$result"
)

alias imgdiff=pngdiff
alias imgdiffs=pngdiffs
alias gimgdiff=pngdiff
alias gimgdiffs=pngdiffs
