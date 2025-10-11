#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=== Dotfiles Setup ==="
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
echo ""

# Check if command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Install packages based on OS
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
        yay -S --needed hyprland hyprpaper hyprlock hypridle
      fi
      ;;

    debian)
      echo "Installing packages via apt..."
      sudo apt update

      # Add repositories if needed
      if ! command_exists gh; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
      fi

      sudo apt install -y \
        fish \
        neovim \
        tmux \
        gh \
        fzf

      # Install from other sources
      if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh
      fi

      if ! command_exists eza; then
        echo "eza not available in apt, skipping..."
      fi

      if ! command_exists mise; then
        curl https://mise.run | sh
      fi

      if ! command_exists ghostty; then
        echo "Installing ghostty..."
        echo "Note: Ghostty may need to be built from source on Debian/Ubuntu"
        echo "See: https://ghostty.org/docs/install/build"
      fi

      echo "Note: Some tools may need manual installation on Debian/Ubuntu"
      ;;

    *)
      echo "Unsupported OS. Please install dependencies manually:"
      echo "  - fish"
      echo "  - starship"
      echo "  - neovim"
      echo "  - tmux"
      echo "  - gh (GitHub CLI)"
      echo "  - eza"
      echo "  - lazygit"
      echo "  - mise"
      echo "  - btop"
      echo "  - fzf"
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
echo "Running install.sh to create symlinks..."
"$DOTFILES_DIR/install.sh"

# Set fish as default shell
if command_exists fish; then
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo ""
    read -p "Set fish as default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
      fi
      chsh -s "$FISH_PATH"
      echo "Fish is now your default shell (restart terminal to apply)"
    fi
  fi
fi

# Setup fzf for fish
if command_exists fish && command_exists fzf; then
  echo ""
  echo "Installing fzf.fish plugin..."
  fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "Note: Install fisher first: fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'"
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Open Neovim to install plugins: nvim"
echo "  3. Configure gh: gh auth login"
echo ""
