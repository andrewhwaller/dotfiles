#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=================================="
echo "Dotfiles Setup"
echo "=================================="
echo ""

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ -f /etc/arch-release ]]; then
    echo "arch"
  elif [[ -f /etc/debian_version ]]; then
    echo "debian"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
echo "Detected OS: $OS"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# Check if command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to create symlink safely
create_symlink() {
    local src="$1"
    local dest="$2"
    local dest_dir=$(dirname "$dest")

    # Create parent directory if needed
    mkdir -p "$dest_dir"

    # Backup existing files
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "  Backing up: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Remove old symlink if it exists
    [[ -L "$dest" ]] && rm "$dest"

    # Create symlink
    ln -s "$src" "$dest"
    echo "  ✓ Linked: $dest"
}

# Function to setup machine-specific config
# This creates symlinks for machine-specific configs based on hostname
# Pattern: config.$HOSTNAME.conf -> config.machine.conf
# Usage: setup_machine_config "config_name" "source_dir" "dest_path"
# Example: setup_machine_config "envs" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/envs.machine.conf"
setup_machine_config() {
    local config_name="$1"
    local source_dir="$2"
    local dest_path="$3"
    local hostname=$(cat /etc/hostname 2>/dev/null || echo "unknown")
    local source_file="$source_dir/${config_name}.$hostname.conf"

    if [[ -f "$source_file" ]]; then
        echo "  Found machine-specific $config_name config for $hostname"
        create_symlink "$source_file" "$dest_path"
    else
        # Create empty file to prevent source errors
        if [[ ! -f "$dest_path" ]]; then
            echo "  Creating empty ${config_name}.machine.conf (no host-specific config)"
            touch "$dest_path"
        fi
    fi
}

# ==========================================
# 1. Install Packages
# ==========================================
install_packages() {
  case "$OS" in
    macos)
      if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi

      echo "Installing packages via Homebrew..."
      brew install \
        fish \
        starship \
        neovim \
        tmux \
        gh \
        eza \
        lazygit \
        mise \
        btop \
        fzf

      brew install --cask ghostty

      # Optional: Install opencode
      read -p "Install opencode? (y/n) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install sst/tap/opencode
      fi
      ;;

    arch)
      echo "Installing packages via pacman/yay..."

      # Check if yay is installed, install if not
      if ! command_exists yay; then
        echo "Installing yay..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
      fi

      # Install packages
      yay -S --needed \
        fish \
        starship \
        neovim \
        tmux \
        github-cli \
        eza \
        lazygit \
        mise \
        btop \
        fzf \
        ghostty

      # Optional: Hyprland ecosystem
      read -p "Install Hyprland and related tools? (y/n) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        yay -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-gtk
      fi
      ;;

    debian)
      echo "Installing packages via apt..."
      sudo apt update
      sudo apt install -y gpg wget

      # Add gh repository
      if ! command_exists gh; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
      fi

      # Add eza repository
      if ! command_exists eza; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
      fi

      sudo apt install -y fish neovim tmux gh fzf eza

      # Install from other sources
      if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh
      fi

      if ! command_exists mise; then
        curl https://mise.run | sh
      fi

      if ! command_exists lazygit; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        rm lazygit lazygit.tar.gz
      fi

      if ! command_exists ghostty; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
      fi

      echo "Note: btop may need manual installation on Debian/Ubuntu"
      ;;

    *)
      echo "Unsupported OS. Please install dependencies manually:"
      echo "  - fish, starship, neovim, tmux, gh (GitHub CLI)"
      echo "  - eza, lazygit, mise, btop, fzf, ghostty"
      exit 1
      ;;
  esac
}

# Install packages
read -p "Install/update packages? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_packages
fi
echo ""

# ==========================================
# 2. Set Fish as Default Shell
# ==========================================
if command_exists fish; then
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "=== Fish Shell ==="
    read -p "Set fish as default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
      fi
      chsh -s "$FISH_PATH"
      echo "  ✓ Fish set as default shell (restart terminal to apply)"
    fi
    echo ""
  fi
fi

# ==========================================
# 3. Install Fisher & Fish Plugins
# ==========================================
if command_exists fish; then
  echo "=== Fisher & Fish Plugins ==="
  if [[ ! -f "$HOME/.config/fish/functions/fisher.fish" ]]; then
      echo "Installing Fisher plugin manager..."
      fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
      echo "  ✓ Fisher installed"
  else
      echo "Fisher already installed ✓"
  fi

  # Install fzf.fish plugin
  if command_exists fzf; then
    echo "Installing fzf.fish plugin..."
    fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "  ✓ fzf.fish already installed"
  fi
  echo ""
fi

# ==========================================
# 4. Create Symlinks
# ==========================================
echo "=== Core Configuration Files ==="

# Setup Ghostty machine-specific config (before symlinking the directory)
echo "Setting up Ghostty machine-specific configuration..."
setup_machine_config "config" "$DOTFILES_DIR/ghostty" "$DOTFILES_DIR/ghostty/config.machine.conf"

create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/gh-dash" "$HOME/.config/gh-dash"
create_symlink "$DOTFILES_DIR/opencode" "$HOME/.config/opencode"

# GTK dark theme preference
create_symlink "$DOTFILES_DIR/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
create_symlink "$DOTFILES_DIR/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

# On macOS, copy theme.conf example if it doesn't exist
if [[ "$OS" == "macos" && ! -f "$HOME/.config/ghostty/theme.conf" ]]; then
    echo "  Creating Ghostty theme.conf from example..."
    cp "$DOTFILES_DIR/ghostty/theme.conf.example" "$HOME/.config/ghostty/theme.conf"
fi
echo ""

# ==========================================
# 5. Linux-Specific (Hyprland)
# ==========================================
if [[ "$OS" == "arch" ]]; then
    echo "=== Linux-Specific Configs ==="

    # Check if Hyprland is installed
    if command_exists hyprctl; then
        echo "Hyprland detected ✓"
        echo "Deploying Hyprland configuration..."

        # Setup machine-specific configs
        echo "Setting up machine-specific Hyprland configuration..."
        setup_machine_config "envs" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/envs.machine.conf"
        setup_machine_config "autostart" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/autostart.machine.conf"

        # Create monitors.conf if it doesn't exist (before symlinking)
        if [[ ! -f "$HOME/.config/hypr/monitors.conf" ]]; then
            echo "  Creating monitors.conf from example (customize for your setup)"
            cp "$DOTFILES_DIR/hypr/monitors.conf.example" "$HOME/.config/hypr/monitors.conf"
        else
            echo "  ✓ monitors.conf already exists"
        fi

        # Symlink hyprland.conf and discrete config files
        create_symlink "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
        create_symlink "$DOTFILES_DIR/hypr/input.conf" "$HOME/.config/hypr/input.conf"
        create_symlink "$DOTFILES_DIR/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
        create_symlink "$DOTFILES_DIR/hypr/envs.conf" "$HOME/.config/hypr/envs.conf"
        create_symlink "$DOTFILES_DIR/hypr/looknfeel.conf" "$HOME/.config/hypr/looknfeel.conf"
        create_symlink "$DOTFILES_DIR/hypr/autostart.conf" "$HOME/.config/hypr/autostart.conf"
        create_symlink "$DOTFILES_DIR/hypr/mocha.conf" "$HOME/.config/hypr/mocha.conf"
        create_symlink "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
        create_symlink "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
        create_symlink "$DOTFILES_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
        create_symlink "$DOTFILES_DIR/hypr/wofi" "$HOME/.config/hypr/wofi"
        create_symlink "$DOTFILES_DIR/hypr/scripts" "$HOME/.config/hypr/scripts"
        create_symlink "$DOTFILES_DIR/hypr/wallpapers" "$HOME/.config/hypr/wallpapers"

        # Configure dark mode preferences for GTK apps
        echo "Configuring dark mode preferences..."
        if command -v gsettings &> /dev/null; then
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
            echo "  ✓ GTK color scheme set to prefer-dark"
        fi

        # Restart portal service if running
        if systemctl --user is-active --quiet xdg-desktop-portal.service; then
            echo "  Restarting xdg-desktop-portal service..."
            systemctl --user restart xdg-desktop-portal.service
            echo "  ✓ Portal service restarted"
        fi
    else
        echo "Hyprland not detected, skipping Hyprland configs"
    fi
    echo ""
fi

# ==========================================
# 6. Optional Configs
# ==========================================
echo "=== Optional Configs ==="

# Doom Emacs (if doom exists)
if [[ -d "$HOME/.config/doom" ]]; then
    create_symlink "$DOTFILES_DIR/doom/config.el" "$HOME/.config/doom/config.el"
fi

# Zsh (optional fallback)
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
fi
echo ""

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins"
echo "  3. Configure gh: gh auth login"
if command_exists hyprctl; then
    echo "  4. Reload Hyprland: hyprctl reload"
fi
echo ""
