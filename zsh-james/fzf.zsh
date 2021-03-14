export FZF_DEFAULT_COMMAND="fd --type f"
FZF_COMPLETION_TRIGGER="?"
FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude ".git" . "

if ! hash fzf 2> /dev/null; then
	zinit ice wait"1" from"gh-r" as"program" lucid
	zinit light junegunn/fzf-bin
fi

# If on nix, use nix's fzf-share. Otherwise, use zinit to download the latest completion and keybindings
if [ -n "${commands[fzf-share]}" ]; then
	source "$(fzf-share)/key-bindings.zsh"
	source "$(fzf-share)/completion.zsh"
elif [[ -d "$HOME/result/sw/share/fzf" ]]; then
	# auto-completion
	[[ $- == *i* ]] && source "$HOME/result/sw/share/fzf/completion.zsh" 2> /dev/null
	# key bindings
	source "$HOME/result/sw/share/fzf/key-bindings.zsh"
else
	zinit ice wait lucid
	zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
	zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
fi

# Use fd for compgen as well
_fzf_compgen_path() {
	fd --hidden --follow --exclude .git . "$1"
}
_fzf_compgen_dir() {
	fd --type d --hidden --follow --exclude .git . "$1"
}
