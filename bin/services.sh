#!/usr/bin/env bash

set -euo pipefail

USER_SERVICES=(
  hypridle.service
  hyprpaper.service
  hyprsunset.service
  mako.service
  waybar.service
  hyprpolkitagent.service
)

echo ":: Reloading user services..."
systemctl --user daemon-reload

echo ":: Enabling Hyprland session services..."
systemctl --user enable --now "${USER_SERVICES[@]}"
