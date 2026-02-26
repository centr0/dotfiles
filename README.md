# centr0's dotfiles

---

## System

- **OS**: Linux
- **Desktop**: Hyprland (Wayland compositor)
- **Shell**: Zsh + Oh My Zsh
- **Terminal**: Ghostty
- **Bar**: Waybar
- **Launcher**: Wofi
- **Multiplexer**: Tmux
- **Editor**: Neovim

---

## Quick Start

```bash
# 1. Install packages (run once on fresh system)
./bin/dotfiles.sh --install

# 2. Push configs to $HOME/.config/
dev --push

# 3. Setup systemd user services
./bin/services.sh

# 4. Pull changes from $HOME back to repo
dev --pull

# 5. Save and push to git
dev --save
```

---

## Structure

```
.
├── bin/
│   ├── dotfiles.sh      # Main CLI: --install, --push, --pull, --save
│   ├── services.sh      # Setup systemd user services
│   └── utils/           # Local scripts (wallpaper, wifi, etc.)
├── config/
│   ├── ghostty/         # Terminal config
│   ├── hypr/            # Window manager config
│   ├── keyboard/        # Keyboard layouts
│   ├── mako/            # Notification daemon
│   ├── tmux/            # Terminal multiplexer
│   ├── vscode/          # Editor settings
│   ├── waybar/          # Status bar
│   └── wofi/            # App launcher
├── aliases              # Shell aliases
├── binds                # Keybindings
├── exports              # Environment variables
├── functions            # Shell functions
├── paths                # PATH additions
├── zshrc                # Zsh config (sources above files)
└── zprofile             # Login shell config
```

---

## Packages

**Core/Base**: base-devel, fzf, jq, man-db, neofetch, openssh, python, ttf-font-awesome, ttf-jetbrains-mono-nerd, wl-clipboard, wlr-randr, zathura, zathura-pdf-poppler, git, rsync, zsh, slurp, ripgrep, bat, btop, firefox, grim, fwupd, wavemon, curl, tree

**Hyprland**: hyprland, hypridle, hyprlock, hyprpaper, xdg-desktop-portal-hyprland, qt5-wayland, qt6-wayland, uwsm

**Terminal/Shell**: ghostty, tmux, oh-my-zsh

**UI/Launcher**: waybar, wofi, mako, nautilus

**Tools**: neovim, discord, 1password, paru

---

## Key Aliases

| Alias | Command |
|-------|---------|
| `dev` | `./bin/dotfiles.sh` |
| `reload` | `source ~/.zshrc` |
| `l`, `ll`, `la` | `ls` variants |
| `..`, `...`, `....` | Quick cd up |
| `gs`, `ga`, `gc`, `gp` | Git commands |
| `fd` | Fuzzy find directory |
| `fh` | Fuzzy find directory (from here) |
| `gtf` | Fuzzy find file + open in nvim |
| `slsl` | Check systemd slice status |

---

## Environment Variables

- `XDG_CONFIG_HOME` → `$HOME/.config`
- `WAYLAND_DISPLAY` → `wayland-1`
- `QT_QPA_PLATFORM` → `wayland`
- `GDK_BACKEND` → `wayland`
- `SDL_VIDEODRIVER` → `wayland`
- `MOZ_ENABLE_WAYLAND` → `1`

---

## Services

The `services.sh` script sets up user-level systemd services separated into slices:

- `app-graphical.slice` - Graphical applications
- `background-graphical.slice` - Background graphical services
- `session.slice` - Session services

---
