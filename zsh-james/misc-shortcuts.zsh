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

# Kubernetes
function kpods {
	kubectl get pods -o custom-columns=:metadata.name --no-headers -l "app=$1"
}
function kdbg {
	echo "Be sure to first run this and allow port forwarding and use --inspect:"
	echo "   kubectl edit deployment $1"
	echo "Example of what you'd add to the YAML:"
	echo "        ports:"
	echo "        - containerPort: 1234"
	echo "          name: http"
	echo "          protocol: TCP"
	echo "        - containerPort: 9229"
	echo "          name: debug"
	echo "          protocol: TCP"
	echo "        command:"
	echo "          - sh"
	echo "          - '-c'"
	echo "          - 'node --inspect ./app.js'"
	echo "That all goes inside spec.template.metadata.spec.containers"
	echo "Note that there will already be a ports defined in there, and maybe even a command!"
	echo "Also note that 'node --inspect ./app.js' may not be right for every app."
	echo "Check the Dockerfile and package.json scripts to see what all you may need to run."
	echo "You'll also need to wait for your new pods to be running and to replace the old ones."
	echo "For that, run:"
	echo "  watch -n 0.5 kubectl get pods -l app=$1"
	echo
	read -k "?Hit enter when you've done all the above"
	echo "Open Chrome and go to chrome://inspect"
	echo "You can also configure chrome to allow some ports above 9229"
	LOCAL_PORT=9229;
	CONCURRENTLY_ARGS="-k"
	for POD_NAME in $(kpods "$1"); do
			CONCURRENTLY_ARGS="$CONCURRENTLY_ARGS\n'kubectl port-forward $POD_NAME $LOCAL_PORT:9229'"
			let LOCAL_PORT+=1
	done
	echo $CONCURRENTLY_ARGS | xargs npx concurrently
}
