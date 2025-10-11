# Auto-start tmux
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
  if tmux has-session -t home 2>/dev/null; then
    exec tmux attach-session -t home
  else
    exec tmux new-session -s home
  fi
fi

export EDITOR=nvim

# Aliases
alias v="nvim"
alias lg="lazygit"
alias coffee="ssh terminal.shop"

# Only set eza alias if eza is installed
if command -v eza &> /dev/null; then
  alias ez="eza --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
fi

# Disable Spring
export DISABLE_SPRING=1

# Linux-specific
if [[ "$(uname)" == "Linux" ]]; then
  export SIGNAL_PASSWORD_STORE=gnome-libsecret
fi

# Path setup
export BUN_INSTALL="$HOME/.bun"
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  "$BUN_INSTALL/bin"
  /Applications/Postgres.app/Contents/Versions/latest/bin
  "$HOME/.config/composer/vendor/bin"
  "$HOME/.opencode/bin"
  $path
)

# mise
if [[ -f "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# Clear biber cache function
clear_biber_cache() {
  if ! command -v biber &> /dev/null; then
    echo "biber not found"
    return 1
  fi

  local cache_path
  cache_path=$(biber --cache 2>/dev/null)

  if [[ -z "$cache_path" ]]; then
    echo "Failed to get biber cache path"
    return 1
  fi

  # Trim whitespace
  cache_path="${cache_path#"${cache_path%%[![:space:]]*}"}"
  cache_path="${cache_path%"${cache_path##*[![:space:]]}"}"

  if [[ ! -d "$cache_path" ]]; then
    echo "Cache path $cache_path does not exist"
    return 0
  fi

  rm -rf "$cache_path"
  echo "Removed $cache_path"
}

# tmux git autofetch
if [[ -f "$HOME/.tmux/plugins/tmux-git-autofetch/git-autofetch.tmux" ]]; then
  tmux-git-autofetch() {
    ("$HOME/.tmux/plugins/tmux-git-autofetch/git-autofetch.tmux" --current &)
  }
  autoload -U add-zsh-hook
  add-zsh-hook chpwd tmux-git-autofetch
fi
