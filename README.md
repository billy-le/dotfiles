# My Dot Files

This repository is my personal dot files

My current setup is:

- Terminal - WezTerm
- Editor - Neovim
- Shell - ZSH

## Prerequisite

- Install Homebrew
- Install git, fzf with homebrew

## Installation

[How to Store Dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

1. Ensure zsh is installed
2. add `alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'`
3. echo ".cfg" >> .gitignore
4. run `git clone --bare https://github.com/billy-le/dotfiles.git $HOME/.cfg`
5. run `dotfiles checkout`
6. run `dotfiles config --local status.showUntrackedFiles no`

