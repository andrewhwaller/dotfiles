if status is-interactive
  and not set -q TMUX
  tmux has-session -t home 2>/dev/null; or tmux new-session -d -s "home" \;
  tmux attach-session -t home 
end

export EDITOR=nvim

alias riptear="/usr/bin/open -a '/Applications/Brave Browser.app' 'https://www.youtube.com/watch?v=KO-2rDf3SXg&t=1s'"
alias ez="eza --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
alias v="nvim"
alias lg="lazygit"
alias coffee="ssh terminal.shop"

fzf_configure_bindings --directory=\cf --variables=\e\cv

set -U fish_greeting
set -x DISABLE_SPRING 1

if test (uname) = "Linux"
    set -x SIGNAL_PASSWORD_STORE gnome-libsecret
end

set --export BUN_INSTALL "$HOME/.bun"
set -U fish_user_paths /usr/bin $fish_user_paths
set -U fish_user_paths $BUN_INSTALL/bin $fish_user_paths
set -U fish_user_paths /Applications/Postgres.app/Contents/Versions/latest/bin $fish_user_paths
set -U fish_user_paths $HOME/.config/composer/vendor/bin $fish_user_paths
set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
set -U fish_user_paths /opt/homebrew/sbin $fish_user_paths

~/.local/bin/mise activate fish | source
starship init fish | source
