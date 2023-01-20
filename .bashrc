# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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

# Adding aliases file for custom permanent aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1='\[\e[0;38;5;46m\]\u\[\e[0;38;5;46m\]@\[\e[0;38;5;46m\]\H\[\e[0m\]:\[\e[0;38;5;51m\]\w \[\e[0;38;5;202m\]$(parse_git_branch)\[\e[0m\]\$ \[\e[0m\]'
export EDITOR='nvim'
NVIMCONF='$HOME/.config/nvim'

# Custom aliases
alias yt='youtube-dl --add-metadata'
alias yta='yt -x -f bestaudio/best'
alias bu='$HOME/Programs/scripts/brightness_up.sh'
alias bd='$HOME/Programs/scripts/brightness_down.sh'
alias upd='sudo dnf check-update --refresh && sudo dnf upgrade -y && flatpak update'
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
