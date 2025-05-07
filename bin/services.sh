#!/usr/bin/env bash
# setup systemd services after uwsm install for hyprland
echo ":: Enabling hypridle, hyprpaper, hyprpolkitagent, hyprsunset, mako, and waybar services..."
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpaper.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now hyprsunset.service
systemctl --user enable --now mako.service
systemctl --user enable --now waybar.service
