alias gal="git add --all"
alias gds="git diff --staged"
alias glt="git log --stat --since=5am --before=11pm"
alias gbold='git branch --merged | grep -Ev "(master|main|\*)"' # Old branches are merged ones that aren't master or main, and also not the current branch
alias gbpurge='gbold | xargs -n 1 git branch -d'
alias glurg="gl && gbpurge"
alias gundo="git reset --soft HEAD~"
alias gforget="git reset --hard HEAD~"
alias glf='git fetch --all; git reset origin/$(git_current_branch) --hard' # analogous to "gpf" which is for force pushing, this is "force pulling"
function gco {
	echo "Use switch or restore instead!"
	echo "gsw, grs, grss, and grst are good ones"
}
function git_default_main_branch {
	if [[ -n "$(gb --list main)" ]]; then
		echo main
	elif [[ -n "$(gb --list master)" ]]; then
		echo master
	fi
}
function gsw {
	if [[ "$#" = "1" ]]; then
		git switch "$1"
		if [[ "$?" != "0" ]] && read -k 1 '?Wanna switch --merge?'; then
			git switch --merge "$1"
		fi
	else
		git switch "$@"
	fi
}
zpcompdef _git gsw='git-switch'

# popd but for branches, and with fzf
function popb {
	gsw $(git reflog --grep-reflog="checkout" -n 5 | awk '!a[$NF]++ { print $NF }' | fzf -1)
}

alias gsm='git fetch origin $(git_default_main_branch); gsw $(git_default_main_branch)'
alias gsml='gsm && git pull'

function git_remote_exists {
	git remote get-url "$1" 2> /dev/null > /dev/null
}
export FORK_REMOTE_NAME=jamescostian
function git_default_push_remote {
	if git_remote_exists $FORK_REMOTE_NAME; then
		echo $FORK_REMOTE_NAME
	else
		echo origin
	fi
}

function gpsup {
	git push --set-upstream "${1:-$(git_default_push_remote)}" $(git_current_branch)
}
zpcompdef __git_remotes gpsup

function gsht {
	git rev-parse --short "${1:-HEAD}"
}
zpcompdef __git_references gsht

function grbf {
	local base_off_of="${1:-$(git_default_main_branch)}"
	local rebase_arguments=()
	if [[ "$2" == "-i" ]]; then
		rebase_arguments+=("-i")
	fi
	rebase_arguments+=("origin/$base_off_of")
	git fetch origin "$base_off_of" && git rebase $rebase_arguments
}
zpcompdef __git_branch_names grbf
function grbif {
	grbf "$1" -i
}
zpcompdef __git_branch_names grbif
alias grbfi="grbif"

alias grbfm='grbf $(git_default_main_branch)'
alias grbm="grbfm"

# Install ghq for cloning repos
zinit ice wait"1" from"gh-r" as"program" lucid mv"ghq*/ghq -> ghq"
zinit light x-motemen/ghq
export GHQ_ROOT="$HOME/code"
export GITHUB_USER=jamescostian # Used when running `ghq create` and when running `ghq get` without any slashes anywhere
alias ghc="ghq create"

# Clone a git repo
function gcl {
	# First, actually clone the repo and cd into it. Try to use ghq, but allow using git if needed (like if ghq isn't available, or you don't have exactly 1 argument)
	if [[ $# = "1" ]] || ! hash ghq > /dev/null; then
		ghq get --vcs git "$1"
		cd "$(ghq list -p "$1")"
	elif [[ $# = "0" ]]; then
		# No arguments were provided! This is totally invalid, show the error and don't bother trying to continue
		git clone
		return $?
	else
		local clone_output=$(mktemp)
		set -o pipefail
		git clone --recurse-submodules --remote-submodules --progress "$@" 2>&1 | tee $clone_output
		local clone_exit="$?"
		if [[ "$clone_exit" != "0" ]]; then
			rm $clone_output
			return $clone_exit
		fi
		cd $(awk -F\' '/Cloning into/ {print $2}' $clone_output)
		rm $clone_output
	fi
	# Try to get setup to work in the project
	if [[ -f "./yarn.lock" ]]; then
		yarn
	elif [[ -f "./package-lock.json" ]]; then
		npm install
	fi
	if [[ -f "./Gemfile" ]]; then
		bundle install
	fi
	if [[ -f "./configure" ]]; then
		./configure
	fi
}
# Clone without typing gcl - just paste a repo URL ending in .git into the terminal and hit enter
alias -s git="gcl"

# cd into a git repo that was cloned using ghq
function hi {
	local project="$(ghq list | fzf -0 -1 -q "$1")"
	[[ -n "$project" ]] && cd "$(ghq list -p -e "$project")"
}

# Setup forgit - interactive (through fzf) git aliases
forgit_diff="gdf"
forgit_add="gai"
forgit_reset_head="grh"
forgit_ignore="gitignore"
zinit ice wait"1" lucid
zinit load wfxr/forgit

# Add some git aliases. This includes aliases for some functions I've defined, so I'm unaliasing them so my function can be run instead
zinit ice wait lucid atload"unalias gcl gpsup gco gsw"
zinit snippet OMZ::plugins/git/git.plugin.zsh
