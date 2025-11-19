# dotfiles

## Installation

### macOS or Linux Desktop

```bash
git clone https://github.com/andrewhwaller/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

Installs and configures: Fish, Starship, Neovim, Tmux, Ghostty, and Hyprland (Linux only).

### Ubuntu Server (Headless)

```bash
git clone https://github.com/andrewhwaller/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## Updating

```bash
cd ~/dotfiles
git pull
./setup.sh  # or ./server-setup.sh on servers
```

## Machine-Specific Configuration (Optional)

By default, the dotfiles work on any machine without additional configuration. However, if you need machine-specific overrides (e.g., different font sizes, window positions, or keybindings per machine), you can create optional config files:

### Terminal Emulators

**Ghostty**: Create `~/dotfiles/ghostty/config.machine.conf` and uncomment the include line in `config`
**Kitty**: Create `~/dotfiles/kitty/config.machine.conf` (automatically loaded if exists)
**Alacritty**: Create `~/dotfiles/alacritty/config.machine.toml` (automatically loaded if exists)

### Hyprland (Linux)

**Monitors**: Edit `~/.config/hypr/monitors.machine.conf` for per-machine monitor layouts
**Autostart**: Create `~/.config/hypr/autostart.machine.conf` for machine-specific startup apps
**Environment**: Create `~/.config/hypr/envs.machine.conf` for machine-specific environment variables

These files are gitignored, so you can customize per-machine without affecting the main configs.
