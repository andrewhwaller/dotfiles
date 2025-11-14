# dotfiles

Personal dotfiles for macOS and Linux

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

### Per-Machine Monitor Config (Hyprland)

Edit `~/.config/hypr/monitors.conf` after first install to set your monitor layout.

## License

MIT
