export DOTFILES=~/dev/dotfiles

source $DOTFILES/config
source $DOTFILES/aliases

source $HOME/antigen.zsh

# antigen settings
antigen use oh-my-zsh
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

antigen apply

# enable colors in prompts
autoload -U colors && colors
setopt promptsubst