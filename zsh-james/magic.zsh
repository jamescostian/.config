autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/knu/zsh-manydots-magic/master/manydots-magic

bindkey " " magic-space
