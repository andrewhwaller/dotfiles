#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=================================="
echo "Dotfiles Server Installation"
echo "=================================="
echo "Target: Ubuntu/Debian Server"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# Check if running on a Debian/Ubuntu system
if ! command -v apt &> /dev/null; then
    echo "Error: This script is for Ubuntu/Debian systems with apt package manager"
    exit 1
fi

# Function to check if a command exists
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

# ==========================================
# 1. Update package list
# ==========================================
echo "=== Updating Package List ==="
sudo apt update
echo ""

# ==========================================
# 2. Install Packages
# ==========================================
echo "=== Installing Packages ==="
sudo apt install -y gpg wget curl

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
echo ""

# ==========================================
# 3. Install Starship
# ==========================================
echo "=== Starship Prompt ==="
if ! command_exists starship; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed ✓"
fi
echo ""

# ==========================================
# 4. Install Additional Tools
# ==========================================
echo "=== Additional Tools ==="

if ! command_exists mise; then
    echo "Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "mise already installed ✓"
fi

if ! command_exists lazygit; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit lazygit.tar.gz
else
    echo "lazygit already installed ✓"
fi
echo ""

# ==========================================
# 5. Set Fish as Default Shell
# ==========================================
echo "=== Fish Shell Setup ==="
FISH_PATH=$(command -v fish)
if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "Setting Fish as default shell..."
    # Add fish to /etc/shells if not already there
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$FISH_PATH"
    echo "  ✓ Fish set as default shell"
else
    echo "Fish is already default shell ✓"
fi
echo ""

# ==========================================
# 6. Install Fisher & Fish Plugins
# ==========================================
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

# ==========================================
# 7. Symlink Core Server Configs
# ==========================================
echo "=== Core Configuration Files ==="
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo ""

# ==========================================
# 8. Optional Configs
# ==========================================
echo "=== Optional Configs ==="

# Zsh (optional fallback)
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    if [[ -d "$DOTFILES_DIR/zsh" ]]; then
        create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
    fi
fi

# Git config (if you have one)
if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi
echo ""

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Server Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins: nvim"
echo "  3. (Optional) Install additional tools with mise: mise use -g node@latest"
echo ""
echo "Server-specific notes:"
echo "  - No GUI applications installed (this is a headless server)"
echo "  - Tmux is configured for remote session management"
echo "  - Fish shell is now your default"
echo ""
