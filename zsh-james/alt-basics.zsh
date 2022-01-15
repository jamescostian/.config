# bat: cat with wings
if ! hash bat 2> /dev/null; then
	zinit ice wait from"gh-r" as"program" mv"bat*/bat -> bat" lucid
	zinit light sharkdp/bat
fi
export BAT_THEME="OneHalfDark"
export BAT_PAGER="less -R"
export BAT_STYLE="plain"
# Replace cat with bat
alias cat="bat --paging never"

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

# exa: ls but nicer
if ! hash exa 2> /dev/null; then
	zinit ice wait from"gh-r" as"program" mv"bin/exa* -> exa" lucid
	zinit light ogham/exa
fi
alias la="exa -la --git --sort=Name --color-scale"
alias l="exa -l --git --sort=Name --color-scale"

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
