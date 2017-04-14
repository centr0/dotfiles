export DEV=~/dev
export DOTFILES=$DEV/dotfiles

source $DOTFILES/config
source $DOTFILES/localrc
source $DOTFILES/aliases
source $DEV/antigen/antigen.zsh
antigen init $DOTFILES/antigenrc