#!/usr/bin/env bash
# Common functions and utilities for dotfiles setup scripts

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export OS="macos"
  elif [[ -f /etc/arch-release ]]; then
    export OS="arch"
  elif [[ -f /etc/debian_version ]]; then
    export OS="debian"
  else
    export OS="unknown"
  fi
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

# Install tmux plugin manager idempotently
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    echo "Installing Tmux Plugin Manager..."
    if [[ -d "$tpm_dir/.git" ]]; then
        echo "✓ TPM already installed"
        return
    fi

    if ! command -v git &> /dev/null; then
        echo "⚠ Git not found, skipping TPM installation"
        echo "  Install git and rerun setup to install TPM"
        return
    fi

    rm -rf "$tpm_dir"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    echo "✓ TPM installed"
}

# Function to setup machine-specific config
# This creates symlinks for machine-specific configs based on hostname
# Pattern: config.$HOSTNAME.ext -> config.machine.ext
# Usage: setup_machine_config "config_name" "source_dir" "dest_path" ["extension"]
# Example: setup_machine_config "envs" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/envs.machine.conf"
# Example: setup_machine_config "config" "$DOTFILES_DIR/alacritty" "$DOTFILES_DIR/alacritty/config.machine.toml" "toml"
setup_machine_config() {
    local config_name="$1"
    local source_dir="$2"
    local dest_path="$3"
    local extension="${4:-conf}"  # Default to .conf if not specified
    local hostname
    hostname=$(hostname -s 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown")
    local source_file="$source_dir/${config_name}.$hostname.$extension"

    if [[ -f "$source_file" ]]; then
        echo "  Found machine-specific $config_name config for $hostname"
        create_symlink "$source_file" "$dest_path"
    else
        # Create empty file to prevent source errors
        if [[ ! -f "$dest_path" ]]; then
            echo "  Creating empty ${config_name}.machine.$extension (no host-specific config)"
            touch "$dest_path"
        fi
    fi
}
