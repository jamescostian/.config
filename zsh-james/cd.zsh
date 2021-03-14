# rupa/z expects a ~/.z to exist, I'm going to make sure it exists before installing z
touch ~/.z
zinit ice wait from"gh" lucid
zinit light rupa/z

# Nix on Droid fix. It's heavy-handed but meh
if [[ "$(uname -m)" == "aarch64" ]]; then
	unsetopt BG_NICE
fi

# Add Ctrl+G for fzf + z
zinit light andrewferrier/fzf-z

setopt autopushd # e.g. `cd x; popd` will go into the directory named "x" and then return back to the original directory
setopt autocd # e.g. type `Downloads` and it will run `cd Downloads` 
setopt nopushdignoredups # e.g. `cd x; cd ../y; cd ../x` will result in the directory named x being in the directory stack twice
setopt pushdminus # e.g. `cd x; cd -1` will change the directory to x and then change back to the previous directory

# I miss these from oh-my-zsh
function take {
	mkdir -p $1
	cd $1
}
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
