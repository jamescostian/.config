# Copy and paste
if [[ "$XDG_SESSION_TYPE" = "x11" ]]; then
	alias cbc="xclip -selection clipboard -i"
	alias cbp="xclip -selection clipboard -o"
else
	alias cbc="wl-copy"
	alias cbp="wl-paste"
fi

# Open things
alias o="xdg-open"

# Just in case $USER isn't defined already
if [[ -z "$USER" ]]; then
	export USER="$(id -un)"
fi

# Can't delete files even as root? unlockshit [FILE...] will fix that.
function unlockshit {
	sudo chattr -i $@
	sudo chattr -a $@
}

# Update, but just a few main things
alias upd="sudo apt update && sudo apt upgrade"
# Full update
function update {
	upd
	# Update everything zinit manages
	zinit update
	# Update FF dev edition. It gets updated really frequently!
	# Might as well download the latest version every time update is called - so long as FF is not running!
	if ! pgrep "firefox-devedition" > /dev/null; then
		curl -L "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" | sudo tar -xjC /opt
		sudo rm -Rf /opt/firefox-devedition
		sudo mv /opt/firefox /opt/firefox-devedition
		sudo mv /opt/firefox-devedition/firefox-bin /opt/firefox-devedition/firefox-devedition-bin
		sudo mv /opt/firefox-devedition/firefox /opt/firefox-devedition/firefox-devedition
	fi
	# Update Mullvad
	wget --content-disposition https://mullvad.net/download/app/deb/latest/ -O mullvad.deb
	sudo dpkg -i mullvad.deb && rm mullvad.deb
	# Update the OS
	do-release-upgrade
}

# NixOS-specific
function nxr {
	if [[ "$1" == "test-vm" ]]; then
		cd /tmp
		nixos-rebuild build-vm
		./result/bin/run-*-vm
	elif [[ "$1" == "edit" || "$1" == "e" ]]; then
		subl /etc/nixos/configuration.nix
	elif [[ "$1" == "s" ]]; then
		sudo nixos-rebuild switch
	elif [[ "$1" == "rollback" ]]; then
		sudo nix-channel --rollback
	else
		sudo nixos-rebuild "$@"
	fi
}
