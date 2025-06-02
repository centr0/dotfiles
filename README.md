# Chris Paraiso's dotfiles

---

## Assumptions

- Arch Linux
- Hyprland (window manager)
- Thinkpad T14 Gen 5 AMD
- Reclaimed virginity
- Fresh install

## Usage

---

1. On a fresh install:
`./dotfiles/bin/dotfiles.sh --install`
This will install all required packages for the environment. Zsh and oh-my-zsh will be installed and the shell will be changed to zsh.
Relogin or restart then me on to step 2.

2. Push configurations to required directories:
`dev --push`
`dev` is just an alias to `/dotfiles/bin/dotfiles.sh`. `--push` will push configurations to their respective directories.

3. Setup systemd services:
`./dotfiles/bin/services.sh`
This will create user level systemd services for applications that need to run in the background. Separating from creating child processes under the compositor.
Restart and confirm services are running on their correct slices with `systemctl --user status app-graphical.slice background-graphical.slice session.slice
`.

After these 3 steps are complete, the environment should be ready to go. Any changes done to the configuration files can be pulled into the dotfiles repository by executing `dev --pull` from the command line.

To save and push changes to git, run `dev --save`.

Holla..
