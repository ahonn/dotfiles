# dotfiles
My vim/neovim, nix, git, and tmux configuration files

![screenshot](./screenshot.png)

## Install
```
$ sh <(curl -L https://nixos.org/nix/install)
$ nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
$ ./result/bin/darwin-installer
$ darwin-rebuild switch --flake .#macbook
```
