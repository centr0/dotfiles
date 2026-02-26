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

## Aliases

| Alias | Command |
|-------|---------|
| `vim` | nvim |
| `venv` | Create and activate virtual environment |
| `reload` | source ~/.zshrc |
| `l` | ls -F |
| `la` | ls -FA |
| `ll` | ls -l |
| `lh` | ls -lAh |
| `..` | cd .. |
| `...` | cd ../.. |
| `....` | cd ../../.. |
| `.....` | cd ../../../.. |
| `d` | cd ~/Desktop |
| `cdl` | cd to dir and list contents |
| `gs` | git status |
| `ga` | git add . |
| `gd` | git ls-files --deleted \| xargs git rm |
| `gc` | git commit |
| `gl` | git log --pretty="%H %s" |
| `gp` | git push |
| `gf` | git difftool |
| `gr` | cd to Git repo root |
| `f` | find -x * -name |
| `gosrc` | cd ~/src |
| `cwd` | Copy working directory to clipboard |
| `cfn` | Copy filename to clipboard |
| `ip` | Copy IP address to clipboard |
| `unpack` | tar -xvzf |
| `tcp` | List processes on port |
| `code` | Open VSCode |
| `chwp` | Change wallpaper |
| `rewifi` | Reset wifi |
| `fd` | Fuzzy find directory |
| `fh` | Fuzzy find directory (from here) |
| `gtf` | Fuzzy find file + open in nvim |
| `slsl` | Check systemd slice status |
| `ax3kmon` | wavemon wifi monitor |

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
