if status is-interactive
and not set -q TMUX
    exec tmux
end

alias riptear="/usr/bin/open -a '/Applications/Brave Browser.app' 'https://www.youtube.com/watch?v=KO-2rDf3SXg&t=1s'"
alias exo="exa --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
alias cht="~/dotfiles/cht.sh"
alias dbui="nvim -c 'DBUI'"
alias dsh="gh dash"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

fzf_configure_bindings --directory=\cf --variables=\e\cv

starship init fish | source
