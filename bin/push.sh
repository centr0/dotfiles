#!/bin/bash
cd "$HOME/src/dotfiles"

git_status=$(git status)
if [[ "$git_status" == *"nothing to commit, working tree clean"* ]]; then
    echo "-- No changes found in the repository. Exiting..."
else
    git add .
    git commit -m "dotfiles update ${timestamp}"
    git push origin master
    echo "-- Update complete."
fi

echo "========================================="
