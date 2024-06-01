if status is-interactive
    and not set -q TMUX
    tmux has-session -t system 2>/dev/null; or tmux new-session -d -s "system" \; send-keys "btop" C-m
    tmux has-session -t github-dash 2>/dev/null; or tmux new-session -d -s "github-dash" \; send-keys "gh dash" C-m
    tmux attach-session -t system
end

alias riptear="/usr/bin/open -a '/Applications/Brave Browser.app' 'https://www.youtube.com/watch?v=KO-2rDf3SXg&t=1s'"
alias exo="exa --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
alias cht="~/dotfiles/cht.sh"
alias dbui="nvim -c 'DBUI'"
alias dsh="gh dash"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias lg="lazygit"

fzf_configure_bindings --directory=\cf --variables=\e\cv

set -U fish_greeting
set -x DISABLE_SPRING 1
set -gx PATH /Users/andrewhwaller/.rbenv/versions/3.2.2/bin $PATH

. (rbenv init - | source)

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
