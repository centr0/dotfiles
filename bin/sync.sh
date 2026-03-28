#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

RSYNC_FLAGS=(--archive --verbose --delete)

usage() {
  cat <<'EOF'
Usage: bin/sync.sh [check|push|pull]

  check  Preview repo -> home sync changes
  push   Sync repo -> home
  pull   Sync home -> repo
EOF
}

run_rsync() {
  local mode="$1"
  shift

  local -a cmd=(rsync "${RSYNC_FLAGS[@]}")

  if [[ "$mode" == "check" ]]; then
    cmd+=(--dry-run)
  fi

  cmd+=("$@")
  "${cmd[@]}"
}

sync_dir() {
  local mode="$1"
  local source_dir="$2"
  local dest_dir="$3"
  shift 3

  mkdir -p "$dest_dir"

  local -a excludes=()
  local pattern
  for pattern in "$@"; do
    excludes+=(--exclude "$pattern")
  done

  run_rsync "$mode" "${excludes[@]}" "$source_dir/" "$dest_dir/"
}

sync_file() {
  local mode="$1"
  local source_file="$2"
  local dest_file="$3"

  if [[ ! -f "$source_file" ]]; then
    echo "Skipping missing file: $source_file"
    return 0
  fi

  mkdir -p "$(dirname -- "$dest_file")"
  run_rsync "$mode" "$source_file" "$dest_file"
}

sync_push() {
  sync_dir "$1" "$REPO_DIR/config/systemd/user" "$CONFIG_DIR/systemd/user"
  sync_dir "$1" "$REPO_DIR/config/ghostty" "$CONFIG_DIR/ghostty"
  sync_dir "$1" "$REPO_DIR/config/hypr" "$CONFIG_DIR/hypr" \
    "monitors.local.conf" \
    "workspaces.local.conf" \
    "hyprpaper.conf"
  sync_dir "$1" "$REPO_DIR/config/mako" "$CONFIG_DIR/mako"
  sync_dir "$1" "$REPO_DIR/config/waybar" "$CONFIG_DIR/waybar" "config.local.jsonc"
  sync_dir "$1" "$REPO_DIR/config/wofi" "$CONFIG_DIR/wofi"
  sync_dir "$1" "$REPO_DIR/bin/utils" "$HOME/.local/scripts"
  sync_file "$1" "$REPO_DIR/config/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

  sync_file "$1" "$REPO_DIR/zshrc" "$HOME/.zshrc"
  sync_file "$1" "$REPO_DIR/zprofile" "$HOME/.zprofile"
}

sync_pull() {
  sync_dir pull "$CONFIG_DIR/systemd/user" "$REPO_DIR/config/systemd/user"
  sync_dir pull "$CONFIG_DIR/ghostty" "$REPO_DIR/config/ghostty"
  sync_dir pull "$CONFIG_DIR/hypr" "$REPO_DIR/config/hypr" \
    "monitors.local.conf" \
    "workspaces.local.conf" \
    "hyprpaper.conf"
  sync_dir pull "$CONFIG_DIR/mako" "$REPO_DIR/config/mako"
  sync_dir pull "$CONFIG_DIR/waybar" "$REPO_DIR/config/waybar" "config.local.jsonc"
  sync_dir pull "$CONFIG_DIR/wofi" "$REPO_DIR/config/wofi"
  sync_dir pull "$HOME/.local/scripts" "$REPO_DIR/bin/utils"
  sync_file pull "$CONFIG_DIR/tmux/tmux.conf" "$REPO_DIR/config/tmux/tmux.conf"

  sync_file pull "$HOME/.zshrc" "$REPO_DIR/zshrc"
  sync_file pull "$HOME/.zprofile" "$REPO_DIR/zprofile"
}

main() {
  if [[ $# -ne 1 ]]; then
    usage
    return 1
  fi

  case "$1" in
    check) sync_push check ;;
    push) sync_push push ;;
    pull) sync_pull ;;
    *)
      usage
      return 1
      ;;
  esac
}

main "$@"
