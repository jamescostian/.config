alias dkrma="docker ps -aq | xargs docker rm -f"

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
