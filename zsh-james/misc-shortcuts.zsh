alias dkrma="docker ps -aq | xargs docker rm -f"
alias curv="curl -v"

alias v="vim"

alias s="sudo"
alias shit='sudo $(fc -ln -1)'

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

alias nr="npm run --silent"
alias npmi="npm i"
alias npmig="npm i -g"

alias y="yarn"
alias ys="yarn start"
alias yd="yarn dev"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yyd="yarn && yarn dev"
alias yys="yarn && yarn start"
alias yt="yarn test"
alias ytc="yarn test --coverage"
alias ytw="yarn test --watch"

# rm -Rf but with confirmation
function rmr {
	TOTAL_SIZE="$(du -shc "$@" | tail -1 | cut -f 1 -)B"
	if read -k "?Hit enter to delete $TOTAL_SIZE or Ctrl+C to cancel"; then
		rm -Rf "$@"
	fi
}

# Extract a .tar.gz or .tgz by just paste a URL ending in .tar.gz or .tgz into the terminal and hitting enter
alias -s {tar.gz,tgz}="remote_tgz_extract"
function remote_tgz_extract {
	if curl -fL "$1" -o tarball.tgz && mkdir tarball && tar -C tarball -xf tarball.tgz; then
		rm tarball.tgz
		# Go into the directory
		pushd tarball > /dev/null 2> /dev/null
		# cd as many times as a human would, while keeping it so that a simple "pushd" will restore the directory previous to this function being run
		replaced_ad_nauseum
		# This makes it easy move on from the archive with a simple `popd; rmr tarball`
	fi
}

# If this dir has 0 files and exactly 1 dir, popd+pushd ("replaced") into it. Hidden files and dirs count towards those numbers.
function replaced_ad_nauseum {
	if [[ "$(ls -A1 | wc -l)" == "1" ]] && [[ -d "$(ls -A1)" ]]; then
		local new_cwd="$PWD/$(ls -A1)"
		popd > /dev/null 2> /dev/null
		pushd "$new_cwd" > /dev/null 2> /dev/null
		replaced_ad_nauseum
	fi
}

# Look at an NPM package locally
function npvw {
	remote_tgz_extract "$(npm view "$1" dist.tarball)"
}

