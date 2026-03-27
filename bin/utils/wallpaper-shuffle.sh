#!/usr/bin/env bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPER_DIR="$XDG_CONFIG_HOME/hypr/wallpapers/"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"

# Persist the selected wallpaper in hyprpaper config.
if [[ -f "$HYPRPAPER_CONF" ]]; then
	escaped_wallpaper=${WALLPAPER//\\/\\\\}
	escaped_wallpaper=${escaped_wallpaper//&/\\&}

	if grep -qE '^\s*preload\s*=' "$HYPRPAPER_CONF"; then
		sed -Ei "0,/^\s*preload\s*=/{s|^\s*preload\s*=.*|preload = $escaped_wallpaper|}" "$HYPRPAPER_CONF"
	else
		printf '\npreload = %s\n' "$WALLPAPER" >> "$HYPRPAPER_CONF"
	fi

	if grep -qE '^\s*wallpaper\s*=' "$HYPRPAPER_CONF"; then
		sed -Ei "s|^(\s*wallpaper\s*=\s*[^,]*,).*|\1$escaped_wallpaper|" "$HYPRPAPER_CONF"
	else
		printf 'wallpaper = ,%s\n' "$WALLPAPER" >> "$HYPRPAPER_CONF"
	fi
fi
