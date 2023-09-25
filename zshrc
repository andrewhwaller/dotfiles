# # If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions rails ruby bundler tmux zsh-syntax-highlighting)

ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='code --wait'
# fi
export EDITOR="nvim"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias obsidian="nvim ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents"
alias nvconfig="nvim ~/.config/nvim/init.vim"
alias zshconfig="nvim ~/.zshrc"
alias dotfiles="cd ~/dotfiles && git status"
alias rubydir="cd ~/RubymineProjects"
alias webdir="cd ~/WebstormProjects"
alias ghdir="cd ~/github"
alias smdir="cd ~/github/servemanager"
alias realp="cd ~/github/real-presence"
alias lukanp="webdir && nvim LukanPrioritiesAstro"
alias riptear="/usr/bin/open -a '/Applications/Brave Browser.app' 'https://www.youtube.com/watch?v=KO-2rDf3SXg&t=1s'"
alias thesis="cd ~/github/thesis"
alias org="cd ~/github/org"
alias exo="LS_COLORS='$(vivid generate one-dark)';exa --color=auto --icons --long -h -a --git --no-permissions --no-user --time=accessed --group-directories-first"
alias cht="~/dotfiles/cht.sh"
alias dm="emacs -nw"
alias ts="$HOME/dotfiles/tmux-sessionizer"
alias dbui="nvim -c 'DBUI'"
alias dsh="gh dash"

export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

_exo_on_cwd_change()  {
  exo
}

(( $+functions[add-zsh-hook] )) || autoload -Uz add-zsh-hook

add-zsh-hook chpwd _exo_on_cwd_change

get_dotfiles() {
  cd ~/dotfiles && git pull --ff-only
}

dev() {
  open "http://localhost:$@"
}

goog() { 
  open /Applications/Brave\ Browser.app/ "http://www.google.com/search?q= $1"; 
}

lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

function chpwd() {
  if [ -r $PWD/.zsh_config ]; then
    source $PWD/.zsh_config
  else
    source $HOME/.zshrc
  fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "/Users/andrewhwaller/.bun/_bun" ] && source "/Users/andrewhwaller/.bun/_bun"

# Bun
export BUN_INSTALL="/Users/andrewhwaller/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LDFLAGS="-L/opt/homebrew/opt/capstone/lib"
export CPPFLAGS="-I/opt/homebrew/opt/capstone/include"
# pnpm
export PNPM_HOME="/Users/andrewhwaller/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
export PATH="$HOME/.config/emacs/bin:$PATH"
# Add Docker Desktop for Mac (docker)
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

eval "$(starship init zsh)"
eval "$(/Users/andrewhwaller/github/scripts/bin/law init -)"
