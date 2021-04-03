#!/usr/bin/env sh
URL_TO_CLONE="https://github.com/jamescostian/.config.git"
export MULTITENANT_SUFFIX="-james"

install_git_if_not_installed () {
	if hash git 2> /dev/null; then
		return
	fi
	if [ "$(uname)" = "Darwin" ]; then
		xcode-select --install
	fi
	# Git isn't installed, so download the installer and run it, then clone with git
	# If you always download the installer, you can't test changes you make to it locally. So allow using an installer if it already exists
	if [ ! -f "install-if-not-exists" ]; then
		cd # Go to home directory, where one has write privileges. RIP if there is no home directory for this user
		# Download a generalized installer that works on many OSes using curl or wget, whichever works, and save to the same filename
		INSTALL_IF_NOT_EXISTS_SCRIPT="https://raw.githubusercontent.com/jamescostian/.config/main/scripts-james/helpers/install-if-not-exists"
		curl -L "$INSTALL_IF_NOT_EXISTS_SCRIPT" -o "install-if-not-exists" 2> /dev/null || wget -qO "install-if-not-exists" "$INSTALL_IF_NOT_EXISTS_SCRIPT"
	fi
	# The generalized installer is ready, time to run it
	sh "install-if-not-exists" git || exit 1
	rm "install-if-not-exists"
}

run_script () {
	if [ -f "$1" ]; then
		./$1
	elif [ -f "$1.zsh" ]; then
		./$1.zsh
	elif [ -f "$1.bash" ]; then
		./$1.bash
	elif [ -f "$1.sh" ]; then
		./$1.sh
	fi
}

main () {
	install_git_if_not_installed
	if [ -f "$HOME/.config/NOT_MULTITENANT$MULTITENANT_SUFFIX" ]; then
		# This has already been set up, and it's not a multitenant installation. Just update it
		cd "$HOME/.config/scripts$MULTITENANT_SUFFIX/helpers"
		git pull && run_script setup-non-multitenant
	elif [ -z "$NOT_MULTITENANT" ] && [ -z "$NMT" ]; then
		# This is a multitenant setup - first install dependencies and clone my config if it's not already there
		if [ ! -d "$HOME/.config/cloned-config$MULTITENANT_SUFFIX" ]; then
			# My config hasn't been cloned before. I'd like to clone it, but what if git isn't even installed?
			git clone "$URL_TO_CLONE" "$HOME/.config/cloned-config$MULTITENANT_SUFFIX" || exit 2
		else
			# This repo was already cloned, so just pull the latest changes
			cd "$HOME/.config/cloned-config$MULTITENANT_SUFFIX/"
			# Only pull if there is a .git folder.
			# This is important because the docker image will be built without the .git folder, so that the image can test the current code, not the very latest code
			if [ -d ".git" ]; then
				git pull || exit 3
			fi
		fi
		# Symlink all multitenant-friendly files/folders
		cd "$HOME/.config"
		ln -s cloned-config$MULTITENANT_SUFFIX/*$MULTITENANT_SUFFIX . 2> /dev/null
		cd "scripts$MULTITENANT_SUFFIX/helpers"
		# Finally, execute the scripts that are fine on multitenant
		run_script setup-multitenant
	else
		mkdir -p "$HOME/.config"
		# Next time this script is run, keep in mind that it's not a multitenant situation
		touch "$HOME/.config/NOT_MULTITENANT$MULTITENANT_SUFFIX"
		# Clone the repo
		git clone $URL_TO_CLONE $HOME/tmp-downloaded-config
		# Move all files from tmp-downloaded-config (from the initial git clone) to $HOME/.config, where they belong.
		# But in order to do that, first recreate the directory structure
		cd "$HOME/tmp-downloaded-config"
		find . -type d -exec mkdir -p ../.config/{} \;
		# Now do the actual moving (excluding .nix files)
		find . -type f -exec mv {} ../.config/{} \;
		# Clean up the temporary directory
		cd
		rm -Rf tmp-downloaded-config
		# And finally, run the non-multitenant setup
		cd ".config/scripts$MULTITENANT_SUFFIX/helpers"
		run_script setup-non-multitenant
		echo "Hit Ctrl+D and start another shell"
	fi
}

main
