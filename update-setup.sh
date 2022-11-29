#!/usr/bin/env bash
# setup.sh takes the existing configuration and writes it, it does _not_ absorb the configuration on your machine; it just overwrites it.
# But what if you have changes on your machine that are worth keeping? Run this script to prevent setup.sh from messing up your setup.

if [[ "$(uname)" = "Darwin" ]]; then
	brew bundle dump --force --file="$HOME/.config/Brewfile$MULTITENANT_SUFFIX"
else
	~/.config/scripts$MULTITENANT_SUFFIX/helpers/list-apt-packages > ~/.config/apt-packages
	~/.config/scripts$MULTITENANT_SUFFIX/helpers/list-snaps-installed > ~/.config/snaps-installed
	dconf dump /desktop/ibus/ > ~/ibus.dconf
fi
code --list-extensions > ~/.config/Code/User/extensions

# Update the version of ~/.ssh/config in 1Password
if [[ -s ~/.ssh/config ]]; then
	eval $(op signin --account costian.1password.com)
	# Remove the old SSH config (1Password's CLI doesn't support updating documents :/)
	op document delete "SSH Config"
	cd ~/.ssh
	op document create config --title "SSH Config"
fi

# TODO: export wifi networks
