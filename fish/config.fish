if status is-interactive
  and not set -q TMUX
  and not set -q SSH_CONNECTION
  if tmux list-sessions &>/dev/null
    tmux attach
  else
    tmux new-session
  end
end

export EDITOR=nvim

alias ez="eza --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
alias v="nvim"
alias lg="lazygit"
alias allmind="~/dotfiles/scripts/tailscale-ssh"

function tmux
    if test (count $argv) -eq 0
        if command tmux list-sessions &>/dev/null
            command tmux attach
        else
            command tmux new-session
        end
    else
        command tmux $argv
    end
end

# Configure fzf keybindings if fzf.fish plugin is installed
if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\cf --variables=\e\cv
end

set -U fish_greeting
set -x DISABLE_SPRING 1

if test (uname) = "Linux"
    set -x SIGNAL_PASSWORD_STORE gnome-libsecret
end

set --export BUN_INSTALL "$HOME/.bun"
fish_add_path /usr/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path /Applications/Postgres.app/Contents/Versions/latest/bin
fish_add_path $HOME/.config/composer/vendor/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Use mise if available (check common locations)
if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
else if command -v mise &> /dev/null
    mise activate fish | source
end

if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

starship init fish | source

# opencode
fish_add_path /Users/andrewhwaller/.opencode/bin

function clear_biber_cache --description "Delete the cache directory returned by 'biber --cache'"
    set -l cache_path_raw (command biber --cache ^/dev/null)
    or begin
        echo "Failed to run biber --cache"
        return 1
    end

    set -l cache_path (string trim -- "$cache_path_raw")
    if test -z "$cache_path"
        echo "biber --cache returned an empty path"
        return 1
    end

    if not test -e "$cache_path"
        echo "Cache path $cache_path does not exist"
        return 0
    end

    command rm -rf -- "$cache_path"
    echo "Removed $cache_path"
end

if test -x ~/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
