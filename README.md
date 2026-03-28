# centr0's dotfiles

Fedora-first dotfiles and desktop bootstrap for a Hyprland workstation.

## What this repo does

- Bootstraps a Fedora machine with the packages needed for this setup.
- Syncs shared config from this repo into `~/.config` and related paths.
- Seeds local override files for monitor and workspace layout.
- Installs and enables `systemd --user` services for the Hyprland session.

## What this repo does not do

- It does not install Discord.
- It does not install 1Password.
- It does not install Spotify.
- It does not clone the Neovim config repo.

Neovim itself is installed by bootstrap. Its config is managed manually from a separate repo.

## Core workflow

### Fresh machine

```bash
./bin/bootstrap.sh
```

That will:

- verify Fedora
- install packages from `packages/*.txt`
- sync shared config into your home directory
- copy local override example files when missing
- reload and enable `systemd --user` services

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

Use this only when you intentionally changed live files under `~/.config` and want those changes brought back into the repo.

## Repo-managed vs local state

This repo is the source of truth for shared config.

Sync uses `rsync --delete`, so files removed from the repo are also removed from managed destinations.

Some files are intentionally treated as machine-local state and are preserved during sync:

- `~/.config/hypr/monitors.local.conf`
- `~/.config/hypr/workspaces.local.conf`
- `~/.config/hypr/hyprpaper.conf`
- `~/.config/waybar/config.local.jsonc`

## Local overrides

Bootstrap seeds these files automatically if they do not already exist:

- `~/.config/hypr/monitors.local.conf`
- `~/.config/hypr/workspaces.local.conf`
- `~/.config/waybar/config.local.jsonc`

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
- `waybar.service`
- `hyprpolkitagent.service`

Repo-managed user units live in `config/systemd/user/` and are synced into `~/.config/systemd/user/`.

If you need to reload and re-enable services manually:

```bash
./bin/services.sh
```

## Structure

```text
.
├── bin/
│   ├── bootstrap.sh
│   ├── dotfiles.sh
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
│   └── wofi/
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
├── zprofile
└── zshrc
```

## Package manifests

- `packages/base.txt` - core CLI and system tools
- `packages/hyprland.txt` - Hyprland session packages
- `packages/desktop-core.txt` - desktop apps and utilities used by shared config
- `packages/dev-core.txt` - core dev tools, including Neovim

## Shell notes

- `zprofile` starts the session through UWSM.
- `zshrc` sources installed shell files from `~/.config`.
- Neovim aliases are kept in place because Neovim is installed by bootstrap.

## Manual installs

After bootstrap, install these manually if you want them:

- Neovim config repo into `~/.config/nvim`
- Discord
- 1Password
- Spotify
