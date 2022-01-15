# Allow typing something and then hitting up and down arrow keys to find a command you ran with that substring (instead of using Ctrl+R)
zinit ice wait lucid
zinit light https://github.com/zsh-users/zsh-history-substring-search
# Bind up and down keys to history-subsring search
[[ ! -z "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ ! -z "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down
# Compatibility fallback for those bindings
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Finally, autosuggestions - see a recently run command that starts the same as what you're typing, and just hit the right arrow key
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light https://github.com/zsh-users/zsh-autosuggestions

# Super important performance boost for fast-syntax-highlighting
pasteinit() {
	OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
	zle -N self-insert url-quote-magic
}
zstyle :bracketed-paste-magic paste-init pasteinit
pastefinish() {
	zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-finish pastefinish

# Load up f-s-y last, and setup completions with it
zinit ice wait atinit"zpcompinit; zpcdreplay" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
