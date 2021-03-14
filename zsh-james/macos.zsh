# Copy and paste
alias cbc="pbcopy"
alias cbp="pbpaste"

# Prepend a command with lmk to get a notification when it finishes
function lmk {
	if $@; then
		osascript -e 'display notification "Finished '"$1"'" sound name "Blow"'
	else
		local exit_code="$?"
		osascript -e 'display notification "ERROR" sound name "Sosumi"'
		exit "$exit_code"
	fi
}

# Open things
alias o="open"

# Can't delete files even as root? unlockshit [FILE] will fix that (usually).
function unlockshit {
	sudo chflags -R noarch $@
	sudo chflags -R nosappnd $@
	sudo chflags -R noschg $@
	sudo chflags -R nouappnd $@
	sudo chflags -R nouchg $@
	csrutil status | grep disabled > /dev/null
	if [[ "$?" == "0" ]]; then
		sudo chflags -R norestricted $@
	else
		tput setaf 3
		echo "I did everything I could."
		echo "If it doesn't work, you may need to disable SIP and try this again."
		echo "To disable SIP:"
		echo
		echo "1. Restart, wait for the bell, then hold Cmd+R for 10 seconds"
		echo "2. Wait for recovery to start, then open the terminal (it's in the menubar)"
		echo "3. Run csrutil disable && reboot"
		tput sgr0
	fi
}

# For iTerm2
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
