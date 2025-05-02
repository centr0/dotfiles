#!/usr/bin/env bash

set -e

# Define config base dir (fallback to ~/.config if not set)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES_DIR="$HOME/src/dotfiles/config"
DOTFILES_REPO="$HOME/src/dotfiles"

check_config_existence() {
  local folders=("${!1}")
  local files=("${!2}")

  if [[ ! -f "$HOME/.zshrc" ]]; then
    echo "-- Error: ZSH not installed. Please install ZSH before continuing." >&2
    exit 1
  fi

  for dir in "${folders[@]}"; do
    if [[ ! -d "$CONFIG_DIR/$dir" ]]; then
      echo "-- Error: Missing folder: $CONFIG_DIR/$dir" >&2
      exit 1
    fi
  done

  for file in "${files[@]}"; do
    if [[ ! -f "$CONFIG_DIR/$file" ]]; then
      echo "-- Error: Missing file: $CONFIG_DIR/$file" >&2
      exit 1
    fi
  done

  echo "-- All required configuration folders, files, and ZSH setup exist."
}

copy_config_to_dotfiles() {
  local folders=("${!1}")
  mkdir -p "$DOTFILES_DIR"

  for dir in "${folders[@]}"; do
    echo "-- Pulling: Copying $CONFIG_DIR/$dir to $DOTFILES_DIR/$dir"
    cp -r "$CONFIG_DIR/$dir" "$DOTFILES_DIR/$dir"
  done
}

copy_dotfiles_to_config() {
  local folders=("${!1}")
  mkdir -p "$CONFIG_DIR"

  for dir in "${folders[@]}"; do
    echo "-- Pushing: Copying $DOTFILES_DIR/$dir to $CONFIG_DIR/$dir"
    cp -r "$DOTFILES_DIR/$dir" "$CONFIG_DIR/$dir"
  done
  echo "-- Installing tmux package manager..."

  if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "-- The tmux package manager is already installed. Skipping..."
  else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "-- tmux package manager has been installed."
  fi

  cp "$HOME/src/dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
  tmux source "$HOME/.tmux.conf"
  echo "-- Configuration for tmux has been installed."
  echo "-- Run <tmux-prefix> + I to install tmux plugins."
}

save_dotfiles_to_git() {
  echo "-- Saving dotfiles to git..."
  cd "$DOTFILES_REPO"

  git_status=$(git status)
  if [[ "$git_status" == *"nothing to commit, working tree clean"* ]]; then
    echo "-- No changes found in the repository. Exiting..."
  else
    git add .
    git commit -m "dotfiles update"
    git push origin master
    echo "-- Update complete."
  fi
}

# Define what to check
required_folders=(
  "ghostty"
  "hypr"
  "mako"
  "waybar"
  "wofi"
  "tmux"
)

required_files=(
  "hypr/hypridle.conf"
  "hypr/hyprland.conf"
  "hypr/hyprpaper.conf"
  "hypr/hyprlock.conf"
  "tmux/tmux.conf"
)

# Parse args
case "$1" in
--pull)
  check_config_existence required_folders[@] required_files[@]
  copy_config_to_dotfiles required_folders[@]
  ;;
--push)
  copy_dotfiles_to_config required_folders[@]
  ;;
--save)
  save_dotfiles_to_git
  ;;
*)
  echo "Usage: dev [--pull | --push | --save]" >&2
  exit 1
  ;;
esac
