alias gsht="git rev-parse --short"
alias gal="git add --all"
alias gds="git diff --staged"
alias gdi="git icdiff"
alias gdis="git icdiff --staged"
alias gdsi="git icdiff --staged"
alias glt="git log --stat --since=5am --before=11pm"
alias gbpurge='git branch --merged | grep -v "\*" | grep -Ev "(master|main") | xargs -n 1 git branch -d'
alias gbold='git branch --merged | grep -v "\*" | grep -Ev "(master|main")'
alias glurg="gl && gbpurge"
alias gundo="git reset --soft HEAD~"
function grbf {
	git fetch origin "$1" && git rebase -i "origin/$1"
}
function gcl {
	local clone_output=$(mktemp)
	git clone --recurse-submodules --remote-submodules --progress "$@" 2>&1 | tee $clone_output
	cd $(awk -F\' '/Cloning into/ {print $2}' $clone_output)
	rm $clone_output
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
# Clone without typing clone
alias -s git="gcl"

# Setup forgit - interactive (through fzf) git aliases
forgit_diff="gdf"
forgit_add="gai"
forgit_reset_head="grh"
forgit_ignore="gitignore"
zinit ice wait"1" lucid
zinit load wfxr/forgit

# Add some git aliases. This includes an alias for gcl, so I'm removing that so that my gcl function can be used instead
zinit ice wait lucid atload"unalias gcl"
zinit snippet OMZ::plugins/git/git.plugin.zsh
