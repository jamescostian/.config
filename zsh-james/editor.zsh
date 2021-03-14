if ! hash code 2> /dev/null; then
	export EDITOR="vim -Nu ~/.config/vimrc$MULTITENANT_SUFFIX"
	export GIT_EDITOR="$EDITOR +startinsert"
else
	export EDITOR="code -w"
	export GIT_EDITOR="$EDITOR"
	# I like to use autocd for my code directory, but I also like `code` to run VS Code
	function code {
		if [[ -d "$PWD/code" && "$#" -eq 0 ]]; then
			cd code
		else
			command code "$@"
		fi
	}
fi
