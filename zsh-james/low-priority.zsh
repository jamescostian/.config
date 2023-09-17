# Put things in here that take a while to load up and don't need to be loaded up ASAP

# Enable thefuck, if it's installed
if hash thefuck 2> /dev/null; then
	eval $(thefuck --alias)
	command_not_found_handler () {
		TF_SHELL_ALIASES=$(alias);
		TF_CMD=$(
			export TF_SHELL_ALIASES;
			export TF_SHELL=zsh;
			export TF_ALIAS=fuck;
			export TF_HISTORY="$@";
			export PYTHONIOENCODING=utf-8;
			thefuck THEFUCK_ARGUMENT_PLACEHOLDER
		) && eval $TF_CMD;
		test -n "$TF_CMD" && print -s $TF_CMD;
	}
fi

# An alias from git-shortcuts will try to overwrite these, so these alias overwrites them to what I want
alias gr='git reset'
alias grbm="grbfm"
