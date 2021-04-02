# Allow my history to be kept separately in a multitenant situation
HISTFILE=$HOME/.cache/zsh_history$MULTITENANT_SUFFIX
# I value history a lot. It's really useful to see old commands I've run.
# So I want a large history, but also, I don't want it to be cluttered with commands I'll never run again
HISTSIZE=10000
SAVEHIST=10000
# Some terminal sessions are a waste of ↑ keystrokes
function junk {
	# The old "unset HISTFILE" isn't working for me anymore, and neither is setting it to /dev/null.
	# So I'm going to ask for no lines of history to be saved:
	HISTSIZE=0
	# Unfortunately, zsh will choose to store 1 line of history, instead of zero!
	# So I'm going to put that line in a temporary file.
	# NOTE: doing something like "mysql ...; je" isn't safe! Run je afterwards
	HISTFILE="$(mktemp)"
}
alias je="junk; exit"

unsetopt inc_append_history
setopt append_history
unsetopt share_history
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
