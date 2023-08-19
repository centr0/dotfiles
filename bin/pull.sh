#!/bin/bash
# pulls any updates from nvchad
echo "========================================="

timestamp=$(date "+%Y%m%d%H%M%S")
nvm_custom="$HOME/.config/nvim/lua/custom"
nvm_dest="$HOME/src/dotfiles/nvchad/"

cp -rf "$nvm_custom"/* "$nvm_dest"
echo "Pulled your custom updates from ~/.config/nvim..."

cp "$HOME/.tmux.conf" "$HOME/src/dotfiles/tmux/tmux.conf"
echo "Pulled your tmux configuration..."

echo "Checking for changes..."

cd "$HOME/src/dotfiles"

git_status=$(git status)

if [[ "$git_status" == *"nothing to commit, working tree clean"* ]]; then
    echo "No changes found in the repository. Exiting..."
else
    git add .
    git commit -m "dotfiles update ${timestamp}"
    git push origin master
    echo "Update complete."
fi

echo "========================================="

