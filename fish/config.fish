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

function __check_nvm --on-variable PWD --description 'Do nvm stuff'
  if test -f .nvmrc
    set node_version (node -v)
    set nvmrc_node_version (nvm list | grep (cat .nvmrc))

    if set -q $nvmrc_node_version
      nvm install
    else if string match -q -- "*$node_version" $nvmrc_node_version
      # already current node version
    else
      nvm use
    end
  end
end

__check_nvm

starship init fish | source
~/.local/bin/mise activate fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -U fish_user_paths /usr/bin $fish_user_paths

fish_add_path /home/andrewhwaller/.spicetify
