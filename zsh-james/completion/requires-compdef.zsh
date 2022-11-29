if hash kubectl 2> /dev/null; then
	source <(kubectl completion zsh)
	alias k="kubectl"
fi
