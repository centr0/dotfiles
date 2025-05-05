#!/usr/bin/env bash
set -e
# Define config base dir (fallback to ~/.config if not set)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES_CONFIG_DIR="$HOME/src/dev-env/dotfiles/config"
DOTFILES_DIR="$HOME/src/dev-env/dotfiles"
LOCAL_SCRIPTS="$HOME/.local/scripts"

# Add dry run flag
DRY_RUN=false

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

  if $DRY_RUN; then
    echo "[DRY RUN] Would create directory: $DOTFILES_CONFIG_DIR (if needed)"
    for dir in "${folders[@]}"; do
      if [ "$dir" == "tmux/tmux.conf" ]; then
        echo "[DRY RUN] Would create directory: $DOTFILES_CONFIG_DIR/tmux (if needed)"
        echo "[DRY RUN] Would copy: $CONFIG_DIR/$dir to $DOTFILES_CONFIG_DIR/tmux/"
      else
        echo "[DRY RUN] Would copy: $CONFIG_DIR/$dir to $DOTFILES_CONFIG_DIR/"
      fi
    done
    echo "[DRY RUN] Would copy: $LOCAL_SCRIPTS/*.sh to $DOTFILES_DIR/bin/utils"
    return
  fi

  cp "$LOCAL_SCRIPTS"/*.sh "$DOTFILES_DIR/bin/utils/"
  echo "-- Pulling: Copying $LOCAL_SCRIPTS/*.sh to $DOTFILES_DIR/bin/utils"

  mkdir -p "$DOTFILES_CONFIG_DIR"
  for dir in "${folders[@]}"; do
    echo "-- Pulling: Copying $CONFIG_DIR/$dir to $DOTFILES_CONFIG_DIR/$dir"
    cp -r "$CONFIG_DIR/$dir" "$DOTFILES_CONFIG_DIR/"
  done
}

copy_dotfiles_to_config() {
  local folders=("${!1}")

  if $DRY_RUN; then
    echo "[DRY RUN] Would create directory: $CONFIG_DIR (if needed)"
    for dir in "${folders[@]}"; do
      echo "[DRY RUN] Would copy: $DOTFILES_CONFIG_DIR/$dir to $CONFIG_DIR/$dir"
    done
    echo "[DRY RUN] Would create directory: $HOME/.local/scripts (if needed)"
    echo "[DRY RUN] Would copy: $DOTFILES_CONFIG_DIR/bin/utils/*.sh to $LOCAL_SCRIPTS"
    echo "[DRY RUN] Would check if tmux package manager is installed"
    echo "[DRY RUN] Would clone tmux package manager from a git repository (if needed)"
    echo "[DRY RUN] Would run: tmux source $HOME/.config/tmux/tmux.conf"
    return
  fi

  mkdir -p "$CONFIG_DIR"
  for dir in "${folders[@]}"; do
    if [ "$dir" == "tmux/tmux.conf" ]; then
      mkdir -p "$DOTFILES_CONFIG_DIR/tmux"
      cp "$DOTFILES_CONFIG_DIR/$dir" "$CONFIG_DIR/$dir"
    else
      cp -r "$DOTFILES_CONFIG_DIR/$dir" "$CONFIG_DIR/$dir"
    fi

    echo "-- Pushing: Copying $DOTFILES_CONFIG_DIR/$dir to $CONFIG_DIR/$dir"
  done

  mkdir -p "$LOCAL_SCRIPTS"
  cp "$DOTFILES_DIR/bin/utils/"*.sh "$LOCAL_SCRIPTS"
  echo "-- Pushing: Copying $DOTFILES_DIR/bin/utils/*.sh to $LOCAL_SCRIPTS"

  echo "-- Installing tmux package manager..."
  if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "-- The tmux package manager is already installed. Skipping..."
  else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "-- tmux package manager has been installed."
  fi

  tmux source "$HOME/.config/tmux/tmux.conf"
  echo "-- Configuration for tmux has been installed."
  echo "-- Run <tmux-prefix> + I to install tmux plugins."
}

save_dotfiles_to_git() {
  echo "-- Checking dotfiles git status..."

  if $DRY_RUN; then
    echo "[DRY RUN] Would change directory to: $DOTFILES_DIR"
    echo "[DRY RUN] Would check git status"
    echo "[DRY RUN] If changes exist, would run:"
    echo "[DRY RUN]   git add ."
    echo "[DRY RUN]   git commit -m \"dotfiles update\""
    echo "[DRY RUN]   git push origin master"
    return
  fi

  cd "$DOTFILES_DIR"
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

to_copy=(
  "ghostty"
  "hypr"
  "mako"
  "waybar"
  "wofi"
  "tmux/tmux.conf"
)

# Parse args and check for dry run flag
for arg in "$@"; do
  if [ "$arg" == "--dryrun" ]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE: No changes will be made ==="
  fi
done

# Process the main command argument
case "$1" in
--pull)
  check_config_existence required_folders[@] required_files[@]
  copy_config_to_dotfiles to_copy[@]
  ;;
--push)
  copy_dotfiles_to_config required_folders[@]
  ;;
--save)
  save_dotfiles_to_git
  ;;
*)
  echo "Usage: dev [--pull | --push | --save] [--dryrun]" >&2
  exit 1
  ;;
esac

if $DRY_RUN; then
  echo "=== DRY RUN COMPLETE: No changes were made ==="
fi
