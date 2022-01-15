# .config

Like a [dotfiles repo](http://dotfiles.github.io/) for `$HOME/.config` instead of `$HOME`, and with support for multitenancy, secrets, and declarative package management

## Install

To try it out (multitenant mode), run this:

```bash
sh -c "`curl -L https://jami.am || wget -qO - https://jami.am`"
ZDOTDIR="$HOME/.config/zsh-james" zsh
```

To install the full version (non-multitenant mode, which only makes sense for me, or for you if you fork and change this repo), run `export NOT_MULTITENANT=true` or `export NMT=y` before running the `sh -c ...` part. The following is how I install this:

```bash
NMT=y sh -c "$(curl -L https://jami.am`)"
```

This does *not* [install the DisplayLink driver](https://support.system76.com/articles/use-docking-station/#installing-displaylink-driver) - something very helpful for using USB-C! If you want video over USB-C, you should definitely install it

## Goals

- **Allow me to set up a new machine** fully (assuming some Ubuntu or derivative OS, apt, snap, and internet access). Not just things like my [.zshrc](zsh-james/.zshrc), but also things like my SSH and GPG keys, and even wifi passwords I've saved (I store all these secrets in 1Password), and even install extensions in VS Codium, or configure `about:config` Firefox settings.
- **Allow me to get a similar set up on a shared user account of an existing machine** - many people make their dotfiles under the assumption that they will have an account which is solely their's, which allows for some simplifications like putting their configuration files in the normal places. But sometimes you need to SSH into a machine and use an account that is shared by others. Having your own `.zshrc`, `.vimrc`, scripts, etc. in the `$HOME` of that shared user account affects others - it's better to allow everyone to have their own, different configurations, and [when each of you SSHs in, you can have your custom shell](scripts-james/helpers/make-ssh-use-my-config)
- Do the above using **idempotent** scripts
- Try to be **declarative** when possible, but not to the extent that it limits the capabilities (for example, NixOS allowed me to have a very declarative configuration, but it also got in my way frequently enough that it wasn't worth the troubles)

Parts of this are not very feasible - for example, I've looked at [Chrome's CLI arguments](https://peter.sh/experiments/chromium-command-line-switches/) and determined that there's just no way I'm going to be able to set up Chrome Sync to make sure all my chrome settings, extensions, and history will be copied between machines. Instead, I'll just have to manually log into Chrome Sync :grimacing:

In addition, having the _exact_ same version of programs will is _not_ a goal of this project. This isn't a production system, it's my personal configuration. Breaking upgrades are fine, I can work around them.

## Conventions

Top-level files/directories that end in `-james` will be symlinked to any machine you install this on, and they don't interfere with system defaults. The uninstaller created on machines for multi-tenant installations will remove those folders, however, it's not a complete uninstaller - that is not an official goal, after all.

While multitenant support is a goal, it can be hard, and in some situations it's much easier to add something which has no effect on 95%+ of developers, but is beneficial to me. For example, [zinit](https://github.com/zdharma-continuum/zinit) will be put in `~/.zinit` instead of getting `-james` added to the end of it; this is fine for anyone else who wants to use zinit, and has no effect on people who don't want to use it. As another example, when I'm logged a machine with a multitenant setup and I want to SSH into another machine with a multitenant setup, I want that to work effortlessly; `ssh othermachine` should give me my setup on that machine (if my setup is available) but not give others my setup. I do this by writing to the user-wide `~/.ssh/config`, but specifying in the `Match` clause to check if a certain environment variable is being set, so that only I am affected by this, keeping with the multi-tenant spirit.

There are other things I'd like to also go into user/global configuration files, but they *would* impact others (such as my whole `~/.config/git/config`), so they are not suitable for multi-tenant installations.

## Updating

To update, simply re-run the installer. If it's not in multi-tenant mode, then `~/.config/setup.sh` can be ran directly as a shortcut.
