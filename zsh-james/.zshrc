#   ____   _____       _____                 _  __ _
#  / __ \ / ____|     / ____|               (_)/ _(_)
# | |  | | (___ _____| (___  _ __   ___  ___ _| |_ _  ___
# | |  | |\___ \______\___ \| '_ \ / _ \/ __| |  _| |/ __|
# | |__| |____) |     ____) | |_) |  __/ (__| | | | | (__
#  \____/|_____/     |_____/| .__/ \___|\___|_|_| |_|\___|
#                           | |
#                           |_|

if [ "$(uname)" = "Darwin" ]; then
	# Copy and paste on a Mac
	alias cbc="pbcopy"
	alias cbp="pbpaste"
	# Integrate with iTerm2
	test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
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

	# Open things
	alias o="open"
else
	# Copy and paste on a Linux machine
	if [[ "$XDG_SESSION_TYPE" = "x11" ]]; then
		alias cbc="xclip -selection clipboard -i"
		alias cbp="xclip -selection clipboard -o"
	else
		alias cbc="wl-copy"
		alias cbp="wl-paste"
	fi

	alias update="sudo nixos-rebuild switch --upgrade"

	# NixOS things
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

	# Can't delete files even as root? unlockshit [FILE...] will fix that.
	function unlockshit {
		sudo chattr -i $@
		sudo chattr -a $@
	}

	# Open things
	alias o="xdg-open"
fi

#  _______ _                                   _____  _             _
# |__   __| |                            _    |  __ \| |           (_)
#    | |  | |__   ___ _ __ ___   ___   _| |_  | |__) | |_   _  __ _ _ _ __  ___
#    | |  | '_ \ / _ \ '_ ` _ \ / _ \ |_   _| |  ___/| | | | |/ _` | | '_ \/ __|
#    | |  | | | |  __/ | | | | |  __/   |_|   | |    | | |_| | (_| | | | | \__ \
#    |_|  |_| |_|\___|_| |_| |_|\___|         |_|    |_|\__,_|\__, |_|_| |_|___/
#                                                              __/ |
#                                                             |___/

if [[ ! -d ~/.zplugin ]]; then
	mkdir ~/.zplugin
	git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi

source ~/.zplugin/bin/zplugin.zsh
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.cache/zsh_history-james

# Set up Oh-My-ZSH plugins and aliases
zplugin ice wait lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin ice wait lucid
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplugin ice wait lucid
zplugin snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh
zplugin ice wait"1" lucid
zplugin snippet OMZ::plugins/docker/_docker
zplugin ice wait lucid
zplugin snippet https://raw.githubusercontent.com/akarzim/zsh-docker-aliases/3b7f40ed1c47c4e47bd2a2846c236cf91603b8c7/alias.zsh

# Set up some programs
if ! hash fzf 2> /dev/null; then
	zplugin ice wait"1" from"gh-r" as"program" lucid
	zplugin load junegunn/fzf-bin
fi
if ! hash bat 2> /dev/null; then
	zplugin ice wait"1" from"gh-r" as"program" lucid
	zplugin load sharkdp/bat
fi
if ! hash fd 2> /dev/null; then
	if hash fdfind 2> /dev/null; then
		alias fd=fdfind
	else
		zplugin ice wait"1" from"gh-r" as"program" lucid
		zplugin load sharkdp/fd
	fi
fi
if ! hash exa 2> /dev/null; then
	zplugin ice wait"1" from"gh-r" as"program" lucid
	zplugin load ogham/exa
fi

# Bat config
export BAT_THEME="OneHalfDark"
export BAT_PAGER="less -R"
export BAT_STYLE="plain"

# Setup fzf
export FZF_DEFAULT_COMMAND='fd --type f'
FZF_CTRL_T_COMMAND='fd --hidden --follow --exclude ".git" . '
if [[ -d "$HOME/result/sw/share/fzf" ]]; then
	# auto-completion
	[[ $- == *i* ]] && source "$HOME/result/sw/share/fzf/completion.zsh" 2> /dev/null
	# key bindings
	source "$HOME/result/sw/share/fzf/key-bindings.zsh"
fi

# Geometry theme config
PROMPT_GEOMETRY_GIT_TIME="false"
PROMPT_GEOMETRY_GIT_CONFLICTS="true"
GEOMETRY_GIT_SEPARATOR=' '
GEOMETRY_SYMBOL_GIT_CLEAN="⬡"
GEOMETRY_SYMBOL_GIT_BARE="⬡"
GEOMETRY_SYMBOL_GIT_DIRTY="⬢"
GEOMETRY_STATUS_COLOR_HASH=true
GEOMETRY_PATH_COLOR=5
GEOMETRY_GIT_NO_COMMITS_MESSAGE="❄new❄ "

PS1="$ " # Temporary prompt until the real one has loaded
zplugin ice from"gh" lucid
zplugin load geometry-zsh/geometry
GEOMETRY_STATUS_COLOR=$(geometry::hostcolor || echo 1)

# Set up some more plugins
zplugin ice from"gh" lucid
zplugin load rupa/z
zplugin ice wait lucid
zplugin load https://github.com/zsh-users/zsh-history-substring-search
# Bind UP and DOWN keys
[[ ! -z "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ ! -z "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down
# bind UP and DOWN arrow keys (compatibility fallback)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Moar completions!
zplugin ice wait blockf lucid atpull'zplugin creinstall -q .'
zplugin load https://github.com/zsh-users/zsh-completions

# Moar plugins!
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin load https://github.com/zsh-users/zsh-autosuggestions

zplugin ice from"gh" wait"0" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting

autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

#     /\   | (_)
#    /  \  | |_  __ _ ___  ___  ___
#   / /\ \ | | |/ _` / __|/ _ \/ __|
#  / ____ \| | | (_| \__ \  __/\__ \
# /_/    \_\_|_|\__,_|___/\___||___/

# Some terminal sessions are a waste of ↑ keystrokes
alias junk="unset HISTFILE"
alias je="junk; exit"

# Alternatives I like
alias nr="npm run --silent"
alias npmi="npm i"
alias npmig="npm i -g"
alias v="vim"
alias s="sudo "
alias la="exa -la --git --sort=Name --color-scale" # ls -lA --color=always
alias l="exa -l --git --sort=Name --color-scale" # ls -l --color=always
# I miss these aliases from oh-my-zsh
alias ...="cd ../.."
alias ....="cd ../../.."

# Convenience helpers
function mkcd {
	mkdir -p $1
	cd $1
}
# I like to use autocd for my code directory, but I also like `code` to run VSCodium
function code {
	if [[ -d "$PWD/code" && "$#" -eq 0 ]]; then
		cd code
	else
		codium "$@"
	fi
}
alias shit='sudo $(fc -ln -1)'
alias pkill="pkill -f" # Sane defaults IMO

# Git-specific things (uses hub for GitHub integration)
alias gsht="git rev-parse --short"
alias gal="git add --all"
alias gds="git diff --staged"
alias gdi="git icdiff"
alias gdis="git icdiff --staged"
alias gdsi="git icdiff --staged"
alias glt="git log --stat --since=5am --before=11pm"
alias gbpurge='git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'
alias gbold='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "rails5_"'
alias glurg="gl && gbpurge"
alias gundo="git reset --soft HEAD~"
function gcl {
	git clone --recurse-submodules --remote-submodules "$@"
	if test "$#" -ne 1; then
		cd "$2"
	else
		cd "$1"
	fi
	if test -f "./package.json"; then
		npm install
	fi
	if test -f "./Gemfile"; then
		bundle install
	fi
	if test -f "./configure"; then
		./configure
	fi
}

function 1p {
	if [[ "$1" != "signin" && "$1" != "signout" && "$1" != "suspend" && "$1" != "reactivate" ]]; then
		# Check if signed in by looking at vaults (takes the least time to load)
		op list vaults > /dev/null 2>&1 || eval $(op signin costian)
	fi
	op "$@"
}

# Global aliases for pipes
alias -g "^"="| head"
alias -g "@"="| tail"
alias -g "\\/"="2>&1 | bat --paging always --style full"
alias -g "?"="2>&1 | cat -A"
alias -g ":s"="| grep --color=auto"
alias -g ":i"="| grep --color=auto -i"
# I like to have global grep aliases for the number of lines of context as well
# I could use $(seq 1 50) but that would be slower, and I never type in-between numbers like :i42
for i in 1 2 3 5 7 8 10 12 15 18 20 30 40 50; do
	alias -g ":$i"="| grep --color=auto --context=$i"
	alias -g ":s$i"="| grep --color=auto --context=$i"
	alias -g ":i$i"="| grep --color=auto --context=$i -i"
done

# Replace cat with bat
alias cat="bat --paging never"

#  __  __ _              _ _
# |  \/  (_)            | | |
# | \  / |_ ___  ___ ___| | | __ _ _ __   ___  ___  _   _ ___
# | |\/| | / __|/ __/ _ \ | |/ _` | '_ \ / _ \/ _ \| | | / __|
# | |  | | \__ \ (_|  __/ | | (_| | | | |  __/ (_) | |_| \__ \
# |_|  |_|_|___/\___\___|_|_|\__,_|_| |_|\___|\___/ \__,_|___/

export MULTITENANT_SUFFIX="-james"
export EDITOR="codium"
export GPG_TTY=$(tty)
export PATH="$HOME/bin:$HOME/.config/scripts-james:$PATH"

# Config for file transfer things
alias rx="wormhole rx --no-listen --accept-file"

# Put my config in .config
alias vim="vim -Nu $HOME/.config/vimrc-james"
export DOCKER_CONFIG="$HOME/.config/docker-james"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep-james"

# GIVE ME COLORS!!!
alias grep="grep --color=auto"

# Enable thefuck, if it's installed
if hash thefuck 2> /dev/null; then
	eval $(thefuck --alias)
fi

# Scroll through things
export LESS=-R

# Useful for a project I'm working on
alias ngrepsip="sudo ngrep -W byline -d any tcp and port 15060"

# Opts zstyles, and bindkeys
unsetopt inc_append_history
setopt append_history
unsetopt share_history
setopt alwaystoend
setopt autocd
setopt autopushd
setopt completeinword
setopt extendedhistory
setopt noflowcontrol
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt interactivecomments
setopt longlistjobs
setopt promptsubst
setopt pushdignoredups
setopt pushdminus

zstyle ':completion:*' menu select
zstyle '*' single-ignored show
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:*:*:users' ignored-patterns sshd 'nixbld*' nm-openvpn nm-iodine nobody system-network sddm messagebus polkituser rtkit
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh-completion"

bindkey "^[OF" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[6~" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[5~" backward-word
bindkey "^[[3~" delete-char
bindkey " " magic-space
bindkey "^H" backward-kill-word
