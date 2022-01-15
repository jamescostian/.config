alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gwl="git worktree list"

function github_forkable_repo_list {
	ghq list | grep -Ev "^github\\.com/$FORK_REMOTE_NAME/"
}

# USAGE: gfrk [fuzzy search parameter to find repo] [new branch name]
#        gfrk [repo to clone using gcl] [new branch name]
function gfrk {
	# First, try to figure out which project to fork using fzf, and allow accepting a search query as an argument, e.g. "gfrk jamescostian/.config"
	local project="$(github_forkable_repo_list | fzf -0 -1 -q "$1")"
	[[ "$?" != "0" ]] && return 1
	# If no project was picked but there was a search query passed in, prompt to clone it
	if [[ -z "$project" && -n "$1" ]]; then
		if read -k 1 "?No such repo found. Hit enter to clone it, or hit Ctrl+C to cancel"; then
			if gcl "$1"; then
				project="$1"
				popd # gcl switched directories; no point putting that in `dirs`, and I have autocd on
			fi
		else
			return 1
		fi
	fi
	if [[ -n "$project" ]]; then
		# The project was cloned if needed, and now it's time to cd into it and setup the fork remote
		hi "$project"
		local project_name="$(basename "$(pwd)")"
		local fork_destination="../../$FORK_REMOTE_NAME/$project_name"
		if [[ -d "$fork_destination" ]]; then
			echo "Dumbass, you already forked that!"
			if read -k 1 "?Ctrl+C to see that fork, or hit enter to overwrite it"; then
				git worktree remove "$fork_dest"
			else
				popd # Undo the cd from running "hi" - I have autocd on, and don't want that call to pollute my `dirs`
				cd "$fork_destination"
				return 1
			fi
		fi
		if ! git remote get-url "$FORK_REMOTE_NAME" > /dev/null 2> /dev/null; then
			git remote add --no-tags "$FORK_REMOTE_NAME" "git@github.com:$FORK_REMOTE_NAME/$project_name.git"
			# TODO: fork on gh if needed
		fi
		# Now it's time to create a worktree on a separate branch, either using what was passed in when calling gfrk, or now, when prompted
		local branch_name="$2"
		[[ -z "$branch_name" ]] && read "?Pick a branch name: " branch_name
		[[ -z "$branch_name" ]] && return 1;
		popd # Undo the cd from running "hi" - I have autocd on, and don't want that call to pollute my `dirs`
		# A branch was specified, so build out a worktree for it
		git worktree add -b "$branch_name" "$fork_destination" origin/$(git_default_main_branch)
		cd "$fork_destination"
	fi
}
function _gfrk {
	local state
	_arguments '1: :->repo' '2: :->branch'
	case $state in
		repo)
			compadd $(github_forkable_repo_list)
			;;
		branch)
			_arguments '2:Branch'
			;;
	esac
}
zpcompdef _gfrk gfrk

function ghotfix_default_hotfix_branch_name {
	date '+hotfix/%Y-%m-%d_%H-%M'
}
# USAGE: ghotfix [hotfix branch name] [original branch name]
function ghotfix {
	local hotfix_branch="${1:-$(ghotfix_default_hotfix_branch_name)}"
	local original_branch="${2:-$(git_default_main_branch)}"
	git worktree add -b $hotfix_branch "$(git rev-parse --show-toplevel)-$(echo $hotfix_branch | sed 's~/~-~g')" origin/$original_branch
}
function _ghotfix {
	local state
	_arguments '1: :->hotfix_branch' '2: :->original_branch'
	case $state in
		hotfix_branch)
			compadd $(ghotfix_default_hotfix_branch_name)
			;;
		original_branch)
			__git_branch_names
			;;
	esac
}
zpcompdef _ghotfix ghotfix
