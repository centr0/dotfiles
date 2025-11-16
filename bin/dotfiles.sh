#!/usr/bin/env bash

set -e

# Define config base dir (fallback to ~/.config if not set)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES_CONFIG_DIR="$HOME/src/dotfiles/config"
DOTFILES_DIR="$HOME/src/dotfiles"

install() {
  local pkgs_dir="$DOTFILES_DIR/pkgs"

  if [[ ! -d "$pkgs_dir" ]]; then
    echo "Error: Directory '$pkgs_dir' does not exist."
    return 1
  fi

  if [[ -f "$pkgs_dir/run_first" ]]; then
    bash "$pkgs_dir/run_first" || {
      echo "Error: Failed to run $pkgs_dir/run_first"
      return 1
    }
  fi

  for script in "$pkgs_dir"/*; do
    [[ -e "$script" ]] || continue
    [[ "$(basename "$script")" == "run_first" ]] && continue

    bash "$script" || {
      echo "Error: Failed to run $script"
      return 1
    }
  done

  echo ":: Packages have been installed."
  echo ":: Please run services.sh to enable required services."
}

pull() {
  echo "=========================================="
  echo "Pulling ghostty configuration..."
  rsync -av $CONFIG_DIR/ghostty/ $DOTFILES_CONFIG_DIR/ghostty
  echo "------------------------------------------"
  echo "Pulling hyprland configuration..."
  rsync -av $CONFIG_DIR/hypr/ $DOTFILES_CONFIG_DIR/hypr
  echo "------------------------------------------"
  echo "Pulling mako configuration..."
  rsync -av $CONFIG_DIR/mako/ $DOTFILES_CONFIG_DIR/mako
  echo "------------------------------------------"
  echo "Pulling tmux configuration..."
  rsync -av $CONFIG_DIR/tmux/tmux.conf $DOTFILES_CONFIG_DIR/tmux/tmux.conf
  echo "------------------------------------------"
  echo "Pulling waybar configuration..."
  rsync -av $CONFIG_DIR/waybar/ $DOTFILES_CONFIG_DIR/waybar
  echo "------------------------------------------"
  echo "Pulling wofi configuration..."
  rsync -av $CONFIG_DIR/wofi/ $DOTFILES_CONFIG_DIR/wofi
  echo "------------------------------------------"
  echo "Pulling local scripts..."
  rsync -av $HOME/.local/scripts/ $DOTFILES_DIR/bin/utils
  echo "=========================================="
  echo "Pulling configurations complete."
}

push() {
  echo "=========================================="
  echo "Pushing ghostty configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/ghostty/ $CONFIG_DIR/ghostty
  echo "------------------------------------------"
  echo "Pushing hyprland configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/hypr/ $CONFIG_DIR/hypr
  echo "------------------------------------------"
  echo "Pushing mako configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/mako/ $CONFIG_DIR/mako
  echo "------------------------------------------"
  echo "Pushing tmux configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/tmux/tmux.conf $CONFIG_DIR/tmux/tmux.conf
  echo "------------------------------------------"
  echo "Pushing waybar configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/waybar/ $CONFIG_DIR/waybar
  echo "------------------------------------------"
  echo "Pushing wofi configuration..."
  rsync -av $DOTFILES_CONFIG_DIR/wofi/ $CONFIG_DIR/wofi
  echo "------------------------------------------"
  echo "Pushing local scripts..."
  rsync -av $DOTFILES_DIR/bin/utils/ $HOME/.local/scripts/
  echo "=========================================="
  echo "Pushing configurations complete."
}

save() {
  cd $DOTFILES_DIR

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

main() {
  for arg in "$@"; do
    case "$arg" in
    --pull) pull ;;
    --push) push ;;
    --install) install ;;
    --save) save ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--pull] [--push] [--install]"
      exit 1
      ;;
    esac
  done
}

main "$@"
