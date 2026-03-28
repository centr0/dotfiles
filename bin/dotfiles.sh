#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DOTFILES_CONFIG_DIR="$DOTFILES_DIR/config"

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

main() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [--pull] [--push]"
    return 1
  fi

  for arg in "$@"; do
    case "$arg" in
      --pull) pull ;;
      --push) push ;;
      --install)
        echo "Install workflow moved out of dotfiles.sh. Use bin/bootstrap.sh once it is in place."
        return 1
        ;;
      --save)
        echo "Save workflow was removed. Use git commands explicitly from the repo."
        return 1
        ;;
      *)
        echo "Unknown option: $arg"
        echo "Usage: $0 [--pull] [--push]"
        return 1
        ;;
    esac
  done
}

main "$@"
