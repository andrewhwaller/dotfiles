#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
fi

echo "=================================="
echo "Dotfiles Installation"
echo "=================================="
echo "OS: $OS"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

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
# 1. Install Fish Shell
# ==========================================
echo "=== Fish Shell ==="
if ! command_exists fish; then
    echo "Fish not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install fish
        else
            echo "Error: Homebrew not found. Please install Homebrew first."
            exit 1
        fi
    elif [[ "$OS" == "linux" ]]; then
        if command_exists yay; then
            yay -S --needed --noconfirm fish
        elif command_exists pacman; then
            sudo pacman -S --needed --noconfirm fish
        elif command_exists apt; then
            sudo apt update && sudo apt install -y fish
        else
            echo "Error: Unsupported package manager. Please install fish manually."
            exit 1
        fi
    fi
else
    echo "Fish already installed ✓"
fi

# Set Fish as default shell
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
# 2. Install fzf (if needed)
# ==========================================
echo "=== fzf ==="
if ! command_exists fzf; then
    echo "fzf not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        brew install fzf
    elif [[ "$OS" == "linux" ]]; then
        if command_exists yay; then
            yay -S --needed --noconfirm fzf
        elif command_exists pacman; then
            sudo pacman -S --needed --noconfirm fzf
        elif command_exists apt; then
            sudo apt update && sudo apt install -y fzf
        fi
    fi
else
    echo "fzf already installed ✓"
fi
echo ""

# ==========================================
# 3. Install Starship (if needed)
# ==========================================
echo "=== Starship Prompt ==="
if ! command_exists starship; then
    echo "Starship not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        brew install starship
    elif [[ "$OS" == "linux" ]]; then
        if command_exists yay; then
            yay -S --needed --noconfirm starship
        elif command_exists pacman; then
            sudo pacman -S --needed --noconfirm starship
        elif command_exists apt; then
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi
    fi
else
    echo "Starship already installed ✓"
fi
echo ""

# ==========================================
# 4. Install mise (if needed)
# ==========================================
echo "=== mise ==="
if ! command_exists mise; then
    echo "mise not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        brew install mise
    elif [[ "$OS" == "linux" ]]; then
        if command_exists yay; then
            yay -S --needed --noconfirm mise
        elif command_exists pacman; then
            sudo pacman -S --needed --noconfirm mise
        elif command_exists apt; then
            curl https://mise.run | sh
        fi
    fi
else
    echo "mise already installed ✓"
fi
echo ""

# ==========================================
# 5. Install Fisher & fzf.fish plugin
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
echo "Installing fzf.fish plugin..."
fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "  ✓ fzf.fish already installed"
echo ""

# ==========================================
# 6. Symlink Core Configs (All Platforms)
# ==========================================
echo "=== Core Configuration Files ==="
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/gh-dash" "$HOME/.config/gh-dash"
create_symlink "$DOTFILES_DIR/opencode" "$HOME/.config/opencode"
echo ""

# ==========================================
# 7. Linux-Specific (Hyprland)
# ==========================================
if [[ "$OS" == "linux" ]]; then
    echo "=== Linux-Specific Configs ==="

    # Check if Hyprland is installed
    if command_exists hyprctl; then
        echo "Hyprland detected ✓"
        echo "Deploying Hyprland configuration..."

        # Only create hyprland.conf symlink if it doesn't already exist
        if [[ ! -f "$HOME/.config/hypr/hyprland.conf" ]]; then
            create_symlink "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
        else
            echo "  ✓ hyprland.conf already exists, skipping"
        fi

        # Symlink discrete config files
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

        # Create monitors.conf if it doesn't exist
        if [[ ! -f "$HOME/.config/hypr/monitors.conf" ]]; then
            echo "  Creating monitors.conf from example (customize for your setup)"
            cp "$DOTFILES_DIR/hypr/monitors.conf.example" "$HOME/.config/hypr/monitors.conf"
        else
            echo "  ✓ monitors.conf already exists"
        fi

        # Setup theme integration with Omarchy (if present)
        if [[ -d "$HOME/.config/omarchy/current/theme" ]]; then
            echo "  Omarchy theme system detected"

            # Ghostty theme
            echo "  Linking Ghostty theme to Omarchy current theme..."
            ln -nsf "$HOME/.config/omarchy/current/theme/ghostty.conf" "$HOME/.config/ghostty/theme.conf"
            echo "  ✓ Ghostty will follow Omarchy theme switching"

            # Tmux theme integration
            echo "  Setting up omarchy-tmux plugin..."
            if [[ ! -d "$HOME/.config/tmux/plugins/omarchy-tmux" ]]; then
                echo "  Installing omarchy-tmux..."
                git clone https://github.com/joaofelipegalvao/omarchy-tmux "$HOME/.config/tmux/plugins/omarchy-tmux"

                # Install inotify-tools for auto-reload
                if command_exists yay; then
                    echo "  Installing inotify-tools (required for tmux auto-reload)..."
                    yay -S --needed --noconfirm inotify-tools
                elif command_exists pacman; then
                    echo "  Installing inotify-tools (required for tmux auto-reload)..."
                    sudo pacman -S --needed --noconfirm inotify-tools
                fi

                # Setup systemd service for auto-reload
                if [[ -f "$HOME/.config/tmux/plugins/omarchy-tmux/scripts/omarchy-tmux-install.sh" ]]; then
                    echo "  Setting up omarchy-tmux systemd service for automatic theme reload..."
                    bash "$HOME/.config/tmux/plugins/omarchy-tmux/scripts/omarchy-tmux-install.sh"
                    echo "  ✓ Systemd service enabled (omarchy-tmux-monitor)"
                fi
            else
                echo "  ✓ omarchy-tmux already installed"
            fi

            echo "  Note: Neovim and Tmux automatically detect and use Omarchy themes"
        else
            echo "  Omarchy theme system not detected"
            echo "  Using default theme configs (Catppuccin Mocha)"
        fi
    else
        echo "Hyprland not detected, skipping Hyprland configs"
    fi
    echo ""
fi

# ==========================================
# 8. Optional Configs
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

# Kitty (if you use it)
if command_exists kitty || [[ "$OS" == "linux" ]]; then
    create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
fi
echo ""

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins"
if command_exists hyprctl; then
    echo "  3. Reload Hyprland: hyprctl reload"
fi
echo ""
