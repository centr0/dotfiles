#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PACKAGES_DIR="$REPO_DIR/packages"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

PACKAGE_MANIFESTS=(
  "base.txt"
  "hyprland.txt"
  "desktop-core.txt"
  "dev-core.txt"
)

require_fedora() {
  if [[ ! -r /etc/os-release ]]; then
    echo "Unable to detect operating system: /etc/os-release not found."
    return 1
  fi

  # shellcheck disable=SC1091
  source /etc/os-release

  if [[ "${ID:-}" != "fedora" ]]; then
    echo "This bootstrap is Fedora-only. Detected: ${ID:-unknown}."
    return 1
  fi
}

create_directories() {
  mkdir -p \
    "$CONFIG_DIR" \
    "$CONFIG_DIR/ghostty" \
    "$CONFIG_DIR/hypr" \
    "$CONFIG_DIR/mako" \
    "$CONFIG_DIR/systemd/user" \
    "$CONFIG_DIR/tmux" \
    "$CONFIG_DIR/waybar" \
    "$CONFIG_DIR/wofi" \
    "$HOME/.local/bin" \
    "$HOME/.local/scripts"
}

seed_local_overrides() {
  local source_file dest_file

  for source_file in \
    "$REPO_DIR/config/hypr/monitors.local.conf.example:$CONFIG_DIR/hypr/monitors.local.conf" \
    "$REPO_DIR/config/hypr/workspaces.local.conf.example:$CONFIG_DIR/hypr/workspaces.local.conf" \
    "$REPO_DIR/config/waybar/config.local.jsonc.example:$CONFIG_DIR/waybar/config.local.jsonc"; do
    dest_file="${source_file#*:}"
    source_file="${source_file%%:*}"

    if [[ ! -f "$dest_file" ]]; then
      install -m 644 "$source_file" "$dest_file"
    fi
  done
}

read_manifest_packages() {
  local manifest_path="$1"

  if [[ ! -f "$manifest_path" ]]; then
    echo "Package manifest not found: $manifest_path"
    return 1
  fi

  grep -Ev '^(#|$)' "$manifest_path" || true
}

install_manifest() {
  local manifest_name="$1"
  local manifest_path="$PACKAGES_DIR/$manifest_name"
  mapfile -t packages < <(read_manifest_packages "$manifest_path")

  if [[ ${#packages[@]} -eq 0 ]]; then
    echo "Skipping empty manifest: $manifest_name"
    return 0
  fi

  echo "Installing packages from $manifest_name..."
  sudo dnf install -y "${packages[@]}"
}

install_packages() {
  local manifest

  for manifest in "${PACKAGE_MANIFESTS[@]}"; do
    install_manifest "$manifest"
  done
}

run_sync_if_available() {
  if [[ -x "$REPO_DIR/bin/sync.sh" ]]; then
    "$REPO_DIR/bin/sync.sh" push
  else
    echo "Skipping config sync for now: bin/sync.sh is not in place yet."
  fi
}

print_manual_steps() {
  cat <<'EOF'

Bootstrap completed.

Manual follow-up:
- Edit ~/.config/hypr/monitors.local.conf for this machine.
- Edit ~/.config/hypr/workspaces.local.conf for this machine.
- Edit ~/.config/waybar/config.local.jsonc if you want monitor-specific workspace persistence.
- Clone your Neovim config repo into ~/.config/nvim when you are ready.
- Install Discord manually.
- Install 1Password manually.
- Install Spotify manually.

Still pending in this repo:
- systemd --user service setup
EOF
}

main() {
  require_fedora
  create_directories
  install_packages
  run_sync_if_available
  seed_local_overrides
  print_manual_steps
}

main "$@"
