#!/bin/bash
echo "==============================================="
echo "Running install..."
zshrc_path="$HOME/.zshrc"
zshrc_add='source $HOME/src/dotfiles/zshrc'
if ! grep -qF "$zshrc_add" $zshrc_path; then
    # Append the code if the search line is not found
    echo "# dotfiles" >> "$zshrc_path"
    echo "$zshrc_add" >> "$zshrc_path"
    echo "Dotfiles have been installed."
else
    echo "Dotfiles have already been installed. No changes made."
fi

echo "Installing nvim configuration..."
cp -R "$HOME/src/dotfiles/nvchad/" "$HOME/.config/nvim/lua/custom/"
echo "Configuration for nvim has been installed."

echo "==============================================="
