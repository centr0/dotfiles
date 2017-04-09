export DOTFILES=~/Code/dotfiles

source $DOTFILES/bash/config
source $DOTFILES/bash/aliases

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi