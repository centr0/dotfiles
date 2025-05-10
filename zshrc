#!/usr/bin/env bash
export SRC=$HOME/src
export DOTFILES=$SRC/dev-env/dotfiles
source $DOTFILES/aliases
source $DOTFILES/exports
source $DOTFILES/paths
source $DOTFILES/functions
source $DOTFILES/binds

# required for nvm
source /usr/share/nvm/init-nvm.sh
