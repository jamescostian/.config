#!/usr/bin/env bash
# setup.sh takes the existing configuration and writes it, it does _not_ absorb the configuration on your machine; it just overwrites it.
# But what if you have changes on your machine that are worth keeping? Run this script to prevent setup.sh form messing up your setup!
code --list-extensions > ~/.config/VSCodium/User/extensions
cp /etc/nixos/configuration.nix ~/.config/configuration.nix
