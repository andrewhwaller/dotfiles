eval "$(mise activate zsh)"

tmux-git-autofetch() {(/Users/andrewhwaller/.tmux/plugins/tmux-git-autofetch/git-autofetch.tmux --current &)}
add-zsh-hook chpwd tmux-git-autofetch
    
