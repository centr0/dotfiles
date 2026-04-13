# centr0's dotfiles :)

Shared desktop and shell config for a Hyprland workstation.

## What this repo does

- Syncs shared config from this repo into `~/.config` and related paths.
- Pulls intentional live config changes back into the repo.
- Preserves machine-local monitor, workspace, and Waybar override files.
- Syncs managed `systemd --user` units and provides a helper to enable them.

## What this repo does not do

- It does not install packages.
- It does not install `oh-my-zsh`.
- It does not seed local override files automatically.
- It does not clone the Neovim config repo.

## Core workflow

### Preview config changes

```bash
./bin/sync.sh check
```

This does a dry run of repo -> home sync with `rsync --delete`.

### Push repo changes to your live config

```bash
./bin/sync.sh push
```

This syncs repo-managed files into your home directory and removes stale managed files from the destination.

### Pull live config changes back into the repo

```bash
./bin/sync.sh pull
```

Use this only when you intentionally changed live files and want those changes brought back into the repo.

### Reload and enable managed user services

```bash
./bin/services.sh
```

## Sync coverage

`bin/sync.sh` manages:

- `config/ghostty` <-> `~/.config/ghostty`
- `config/hypr` <-> `~/.config/hypr`
- `config/mako` <-> `~/.config/mako`
- `config/systemd/user/*.service` <-> `~/.config/systemd/user/*.service`
- `config/tmux/tmux.conf` <-> `~/.config/tmux/tmux.conf`
- `config/waybar` <-> `~/.config/waybar`
- `config/wezterm/wezterm.lua` <-> `~/.wezterm.lua`
- `config/wofi` <-> `~/.config/wofi`
- `config/zed` <-> `~/.config/zed`
- `bin/utils/` <-> `~/.local/scripts/`
- `zshrc` <-> `~/.zshrc`

## Repo-managed vs local state

This repo is the source of truth for shared config.

Sync uses `rsync --delete`, so files removed from the repo are also removed from managed destinations.

Some files are intentionally treated as machine-local state and are preserved during sync:

- `~/.config/hypr/monitors.local.conf`
- `~/.config/hypr/workspaces.local.conf`
- `~/.config/hypr/hyprpaper.conf`
- `~/.config/waybar/config.local.jsonc`

## Local overrides

The source examples live in the repo:

- `config/hypr/monitors.local.conf.example`
- `config/hypr/workspaces.local.conf.example`
- `config/waybar/config.local.jsonc.example`

Those example files include inline instructions, but the short version is:

```bash
hyprctl monitors
```

Then:

- copy the monitor names exactly as reported
- set your preferred resolution, refresh, position, and scale in `~/.config/hypr/monitors.local.conf`
- map workspaces to those same monitor names in `~/.config/hypr/workspaces.local.conf`
- optionally set monitor-specific persistent workspaces in `~/.config/waybar/config.local.jsonc`

## Services

This setup uses `systemd --user` for session services.

Managed services:

- `hypridle.service`
- `hyprpaper.service`
- `hyprsunset.service`
- `mako.service`
- `tmux.service`
- `waybar.service`
- `hyprpolkitagent.service`

Repo-managed user units live in `config/systemd/user/` and are synced into `~/.config/systemd/user/`.

## Structure

```text
.
├── bin/
│   ├── services.sh
│   ├── sync.sh
│   └── utils/
├── config/
│   ├── ghostty/
│   ├── hypr/
│   ├── mako/
│   ├── systemd/user/
│   ├── tmux/
│   ├── waybar/
│   ├── wezterm/
│   ├── wofi/
│   └── zed/
├── packages/
│   ├── base.txt
│   ├── desktop-core.txt
│   ├── dev-core.txt
│   └── hyprland.txt
├── aliases
├── binds
├── exports
├── functions
├── paths
└── zshrc
```

## Package manifests

These files are kept as reference only. No repo script installs them.

- `packages/base.txt` - core CLI and system tools
- `packages/hyprland.txt` - Hyprland session packages
- `packages/desktop-core.txt` - desktop apps and utilities used by shared config
- `packages/dev-core.txt` - core dev tools, including Neovim and tmux

## Shell notes

- `~/.zshrc` is synced from this repo.
- `~/.zshrc` sources `exports`, `paths`, `aliases`, `functions`, and `binds` directly from the repo clone.

## Manual installs

Install these yourself if you want them:

- Neovim config repo into `~/.config/nvim`
- Discord
- 1Password
- Spotify
