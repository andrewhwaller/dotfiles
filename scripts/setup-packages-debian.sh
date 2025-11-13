#!/usr/bin/env bash
# Debian/Ubuntu package installation via apt

set -e

echo "=== Debian/Ubuntu Package Installation ==="

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
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

if ! command_exists mise; then
  echo "Installing mise..."
  curl https://mise.run | sh
fi

if ! command_exists lazygit; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm lazygit lazygit.tar.gz
fi

if ! command_exists ghostty; then
  echo "Installing Ghostty..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi

# Install Tmux Plugin Manager (TPM)
echo "Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✓ TPM installed"
else
  echo "✓ TPM already installed"
fi

echo "Note: btop may need manual installation on Debian/Ubuntu"
echo "✓ Debian/Ubuntu packages installed"
echo ""
