# bat: cat with wings
if ! hash bat 2> /dev/null; then
	zinit ice wait from"gh-r" as"program" mv"bat*/bat -> bat" lucid
	zinit light sharkdp/bat
fi
export BAT_PAGER="less -R"
export BAT_STYLE="plain"
# Replace cat with bat, optionally with dark mode vs light mode support for MacOS
if [ "$(uname)" = "Darwin" ]; then
	# Sets an environment variable 1 time which is useful for everything that bundles bat, but won't live-update
	if defaults read -globalDomain AppleInterfaceStyle &> /dev/null; then
		export BAT_THEME="OneHalfDark"
	else
		export BAT_THEME="OneHalfLight"
	fi
	# Every time you run cat, evaluate the light/dark mode setting to choose which theme to use
	alias cat="bat --paging never --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo OneHalfDark || echo OneHalfLight)"
else
	export BAT_THEME="OneHalfDark"
	alias cat="bat --paging never"
fi

# fd: find but nicer
if ! hash fd 2> /dev/null; then
	function fd {
		zinit ice from"gh-r" as"program" atclone"chown -R $USER ." mv"fd*/fd -> fd" lucid
		zinit light sharkdp/fd
		unfunction fd
		fd "$@"
	}
fi
# Use fd but without any excludes except .git
alias fda="fd -IH --exclude .git"

# eza: ls but nicer (maintained version of exa)
if ! hash eza 2> /dev/null; then
	zinit ice wait from"gh-r" as"program" lucid
	zinit light eza-community/eza
fi
alias la="eza -la --git --sort=Name --color-scale"
alias l="eza -l --git --sort=Name --color-scale"

# llama: cd+ls+$EDITOR
if ! hash llama 2> /dev/null; then
	zinit ice wait from"gh-r" as"program" mv"llama* -> llama" lucid
	zinit light antonmedv/llama
fi
function ll {
	cd "$(llama "$@")"
}

# hyperfine: time on steroids
if ! hash hyperfine 2> /dev/null; then
	function hyperfine {
		zinit ice from"gh-r" as"program" atclone"chown -R $USER ." mv"hyperfine*/hyperfine -> hyperfine" lucid
		zinit light sharkdp/hyperfine
		unfunction hyperfine
		hyperfine "$@"
	}
fi

# ripgrep, ripgrep-all (ripgrep but for text in binaries), and batgrep (ripgrep + bat)
if ! hash rg 2> /dev/null; then
	zinit ice wait"1" from"gh-r" as"program" mv"*/rg -> rg" lucid
	zinit light BurntSushi/ripgrep
fi
if ! hash rga 2> /dev/null; then
	function rga {
		zinit ice wait"1" from"gh-r" as"program" mv"*/rga -> rga" cp"*/rga-preproc -> rga-preproc" lucid
		zinit light phiresky/ripgrep-all
		unfunction rga
		rga "$@"
	}
fi
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep$MULTITENANT_SUFFIX"
zinit ice wait"1" as"program" pick"src/batgrep.sh" lucid
zinit light eth-p/bat-extras
alias rg="BAT_STYLE= batgrep.sh --hidden -g '!.git'"

# Misc sane defaults IMO
alias pkill="pkill -f"
zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
