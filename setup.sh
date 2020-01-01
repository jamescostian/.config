#!/usr/bin/env sh
URL_TO_CLONE="https://github.com/jamescostian/.config.git"
export MULTITENANT_SUFFIX="-james"
MY_USER_NAME="james"

main () {
	# If this is being run from install-nixos then allow certain things to be run - see https://github.com/jamescostian/install-nixos
	# If this is being run in a multi-tenant situation,
	# If this is being run from an already-installed-to NixOS with my dotfiles, other things need to run
	if [ ! -z "$RUNNING_FROM_NIXOS_INSTALLER" ]; then
		# The installer has the files in /mnt/etc/nixos instead of /mnt/home/$MY_USER_NAME/.config
		/mnt/etc/nixos/scripts$MULTITENANT_SUFFIX/helpers/move_installer_files_to_dot_config
		mkdir -p "/mnt/home/$MY_USER_NAME/.config"
		cd "/mnt/home/$MY_USER_NAME/.config"
		./make_external_files "/mnt"
		./make_machine.nix_file
	elif [ -f "/etc/NIXOS" ] && [ "$USER" = "$MY_USER_NAME" ]; then
		# This is one of *my machines* running NixOS!
		cd "$HOME/.config/scripts$MULTITENANT_SUFFIX/helpers"
		./ensure_there_is_a_nix_channel
		./make_external_files
		./apply_vscode_extensions
		./apply_nixos_configuration
		./get_secrets
		./clean_up_garbage
	else
		# This is a multitenant setup - first install dependencies and clone my config if it's not already there
		if [ ! -d "$HOME/.config/cloned-config$MULTITENANT_SUFFIX" ]; then
			if ! hash git 2> /dev/null; then
				# Allow a local copy of the file to be used - nice for testing in a docker container using COPY
				if [ ! -f install_if_not_exists ]; then
					cd # Go to home directory, where one has write privileges
					curl -L https://raw.githubusercontent.com/jamescostian/.config/master/scripts-james/helpers/install_if_not_exists -o install_if_not_exists 2> /dev/null || wget -qO install_if_not_exists https://raw.githubusercontent.com/jamescostian/.config/master/scripts-james/helpers/install_if_not_exists
				fi
				sh install_if_not_exists git || exit 1
				rm install_if_not_exists
			fi
			git clone "$URL_TO_CLONE" "$HOME/.config/cloned-config$MULTITENANT_SUFFIX" || exit 2
		else
			cd "$HOME/.config/cloned-config$MULTITENANT_SUFFIX/"
			git pull || exit 3
		fi
		# Symlink all multitenant-friendly files/folders
		cd ~/.config
		ln -s cloned-config$MULTITENANT_SUFFIX/*$MULTITENANT_SUFFIX . 2> /dev/null
		cd "scripts$MULTITENANT_SUFFIX/helpers"
		# Finally, execute the scripts that are fine on multitenant
		./install_if_not_exists bash awk file sudo ssh curl zsh rsync rg
		./make_ssh_use_my_config
		./make_multitenant_uninstaller
	fi
}

main
