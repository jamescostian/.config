# Used to make various things support multitenancy
export MULTITENANT_SUFFIX="-james"

if [ "$(uname)" = "Darwin" ]; then
	source $ZDOTDIR/macos.zsh
else
	source $ZDOTDIR/linux.zsh
fi

if [[ ! -d ~/.zinit ]]; then
	mkdir ~/.zinit
	chmod 0700 ~/.zinit
	git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh

source $ZDOTDIR/docker.zsh
source $ZDOTDIR/fzf.zsh
source $ZDOTDIR/altbasics.zsh
source $ZDOTDIR/theme.zsh
source $ZDOTDIR/cd.zsh
source $ZDOTDIR/shelltricks.zsh
source $ZDOTDIR/history.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/editor.zsh
source $ZDOTDIR/magic.zsh
source $ZDOTDIR/completion.zsh
zinit ice wait"1" lucid
zinit snippet $ZDOTDIR/low-priority.zsh

source $ZDOTDIR/git-shortcuts.zsh
source $ZDOTDIR/git-worktrees.zsh
# Add delta for git diffing
if ! hash delta 2> /dev/null; then
	zinit ice wait"1" from"gh-r" as"program" mv"delta*/delta -> delta" lucid
	zinit light dandavison/delta
fi
# Git config (can't rely on ~/.config/git/config being available in multitenant situations)
export GIT_PAGER="delta --theme OneHalfDark --file-style box --tabs 2"
export GIT_COMMITTER_NAME="James Costian"
export GIT_COMMITTER_EMAIL="james@jamescostian.com"

# Misc
export PATH="$HOME/bin:$HOME/.config/scripts$MULTITENANT_SUFFIX:$HOME/.cargo/bin:$PATH"
export LESS=-R
export GPG_TTY=$(tty)
alias grep="grep --color=auto"
setopt noflowcontrol
setopt interactivecomments
setopt longlistjobs
bindkey "^[OF" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[6~" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[5~" backward-word
bindkey "^[[3~" delete-char
bindkey "^H" backward-kill-word

# Benchmark with hyperfine --warmup 2 'zsh -i -c exit'
