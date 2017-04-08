export DOTFILES=~/dev/dotfiles

source $DOTFILES/config
source $DOTFILES/aliases

source $HOME/antigen.zsh

# enable colors in prompts
autoload -U colors && colors
setopt promptsubst