#!/bin/bash
# pulls any updates from nvchad
echo "========================================="

timestamp=$(date "+%Y%m%d%H%M%S")
nvm_custom="$HOME/.config/nvim/lua/custom"
nvm_dest="$HOME/src/dotfiles/nvchad/"

cp -rf "$nvm_custom"/* "$nvm_dest"

echo "Pulled your custom updates from ~/.config/nvim..."
echo "Checking for changes..."

cd "$HOME/src/dotfiles/nvchad/"

git_status=$(git status)

if [[ "$git_status" == *"nothing to commit, working tree clean"* ]]; then
    echo "No changes found in the repository. Exiting..."
else
    git add .
    git commit -m "nvim custom settings update ${timestamp}"
    git push origin master
    echo "Update complete."
fi

echo "========================================="

