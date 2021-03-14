# Put things in here that take a while to load up and don't need to be loaded up ASAP

# Enable thefuck, if it's installed
if hash thefuck 2> /dev/null; then
	eval $(thefuck --alias)
fi

# An alias from git-shortcuts will try to overwrite `gr` to be `git remote`, so this alias overwrites it to what I want
alias gr='git reset'

# Add 1p, a wrapper around op (1Password CLI) that ensures you're signed in
MY_1PASSWORD_SUBDOMAIN=costian
MY_1PASSWORD_EMAIL=jamescostian@gmail.com
function 1p {
	if [[ "$1" != "signin" && "$1" != "signout" && "$1" != "suspend" && "$1" != "reactivate" ]]; then
		# Check if signed in by looking at vaults (takes the least time to load)
		if ! op list vaults > /dev/null 2>&1; then
			# Not logged in. Try to log in if not already logged in
			if [[ ! -d "$HOME/.op" ]]; then
				# Oh wait, this machine has never been signed in on!
				echo '/!\ Do not type your master password yet! /!\'
				op signin $MY_1PASSWORD_SUBDOMAIN.1password.com $MY_1PASSWORD_EMAIL
			fi
			eval $(op signin $MY_1PASSWORD_SUBDOMAIN)
		fi
	fi
	op "$@"
}
