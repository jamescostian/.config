#!/usr/bin/env bash
# setup.sh takes the existing configuration and writes it, it does _not_ absorb the configuration on your machine; it just overwrites it.
# But what if you have changes on your machine that are worth keeping? Run this script to prevent setup.sh from messing up your setup.

~/.config/scripts-james/helpers/list-apt-packages > ~/.config/apt-packages
~/.config/scripts-james/helpers/list-snaps-installed > ~/.config/snaps-installed
code --list-extensions > ~/.config/Code/User/extensions

# Update the version of ~/.ssh/config in 1Password
if [[ -s ~/.ssh/config ]]; then
	if ! op list vaults > /dev/null 2>&1; then
		# Not logged in. Try to log in if not already logged in
		if [[ ! -d "$HOME/.op" ]]; then
			# Oh wait, this machine has never been signed in on!
			echo '/!\ Do not type your master password yet! /!\'
			op signin costian jamescostian@gmail.com
		fi
		eval $(op signin costian)
	fi
	# Remove the old SSH config (1Password's CLI doesn't support updating documents :/)
	op delete document "SSH Config"
	cd ~/.ssh
	op create document config --title "SSH Config"
fi

# TODO: export wifi networks
