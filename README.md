# .config

Like a [dotfiles repo](http://dotfiles.github.io/) for `$HOME/.config` instead of `$HOME`, and with some special goals

## Install

If you just want to install parts of setup on (almost) any linux machine, you can just run this:

```
sh -c "`curl -L https://jami.am || wget -qO - https://jami.am`"
```

To save on typing, you can usually get away with just this:

```
curl -L https://jami.am|sh
```

If you're using [Nix-on-Droid](https://f-droid.org/en/packages/com.termux.nix/), you can run the above command after first running `nix-env -i curl busybox`

To get everything (even the OS and things like WiFi passwords), use [my NixOS installer](https://github.com/jamescostian/install-nixos#install) and when asked about cloning a URL, type `y` and then `gh:jamescostian/.config` and hit ENTER. After restarting, connect to the internet (setup kwallet if asked to), and then open a terminal and let the last part finish

## Try my shell setup

```
docker run --rm -it jamescostian/dotconfig
```

## Goals

- **Allow me to set up a new machine** fully (assuming my NixOS installer already ran, and internet access is provided). Not just things like my [.zshrc](zsh-james/.zshrc), but also things like my SSH and GPG keys, and even wifi passwords I've saved (I store all these secrets in 1Password), and even install extensions in VS Codium, or configure `about:config` Firefox settings.
- **Allow me to get a similar set up on a shared user account of an existing machine** - many people make their dotfiles under the assumption that they will have an account which is solely their's, which allows for some simplifications like putting their configuration files in the normal places. But sometimes you need to SSH into a machine and use an account that is shared by others. Having your own `.zshrc`, `.vimrc`, scripts, etc. in the `$HOME` of that shared user account affects others - it's better to allow everyone to have their own, different configurations, and [when each of you SSHs in, you can have your custom shell](scripts-james/helpers/make_ssh_use_my_config)
- Do the above using **deterministic**, **idempotent** commands

Parts of this are not very feasible - for example, I've looked at [Chrome's CLI arguments](https://peter.sh/experiments/chromium-command-line-switches/) and determined that there's just no way I'm going to be able to set up Chrome Sync to make sure all my chrome settings, extensions, and history will be copied between machines. Instead, I'll just have to manually log into Chrome Sync

But in order to get as close as possible, I'll be wiping my laptop every so often so I can notice the amount of manual work required, and use my desktop as a reference for how I like things.

## Conventions

Top-level files/directories that end in `-james` will be symlinked to any machine you install this on, and they don't interfere with system defaults. The uninstaller created on machines for multi-tenant installations will remove those folders, however, it's not a complete uninstaller - that is not an official goal, after all.

The goal is to keep this installer as multi-tenant as possible, but sometimes that can be hard, and in some situations it's much easier to add something which has no effect on most people, but is beneficial to me. For example, [zplugin](https://github.com/zdharma/zplugin) will be put in `~/.zplugin` instead of getting `-james` added to the end of it; this is fine for anyone else who wants to use zplugin, and has no effect on people who don't want to use it. As another example, when I'm logged a machine with a multitenant setup and I want to SSH into another machine with a multitenant setup, I want that to work effortlessly; `ssh othermachine` should give me my setup on that machine (if my setup is available) but not give others my setup. I do this by writing to the user-wide `~/.ssh/config`, but specifying in the `Match` clause to check if a certain environment variable is being set, so that only I am affected by this, keeping with the multi-tenant spirit.

There are other things I'd like to also go into user/global configuration files, but they *would* impact others, so they are not suitable for multi-tenant installations.

## Updating

To update, simply re-run the installer. If it's not in multi-tenant mode, then `~/.config/setup.sh` can be ran directly, instead of the whole `sh -c ...` incantation. Idempotency is an explicit goal after all!

## Forking

Unless you like _my_ config, don't fork this; just steal [my `setup.sh`](setup.sh) and change the variables at the top, and the list of scripts I run in the top function, and steal a few of my [helper scripts](scripts-james/helpers)
