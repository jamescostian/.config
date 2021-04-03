# Put things in here that take a while to load up and don't need to be loaded up ASAP

# Enable thefuck, if it's installed
if hash thefuck 2> /dev/null; then
	eval $(thefuck --alias)
fi

# An alias from git-shortcuts will try to overwrite `gr` to be `git remote`, so this alias overwrites it to what I want
alias gr='git reset'
