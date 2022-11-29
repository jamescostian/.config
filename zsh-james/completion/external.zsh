# Add docker completion if it's missing
if ! which _docker > /dev/null; then
	zinit ice wait"1" lucid as"completion"
	zinit snippet OMZ::plugins/docker/_docker
fi

# Moar completions!
zinit ice wait blockf lucid atpull"zinit creinstall -q ." as"completion"
zinit light https://github.com/zsh-users/zsh-completions
