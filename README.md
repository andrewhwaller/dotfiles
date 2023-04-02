# dotfiles
it's vim time, bb

Includes config files for Vim/[MacVim](https://macvim-dev.github.io/macvim/), [zsh](https://www.zsh.org/), [iTerm 2](https://iterm2.com/), [Starship](https://starship.rs/), [Neovim](https://neovim.io/), and Doom (just for org-mode, tho).
## Installation
### zsh
``` shell
brew install zsh
```
### oh-my-zsh
``` shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### iTerm
``` shell
brew install --cask iterm2
```
#### Syncing via Git
This repo includes `get_dotfiles.scpt`, an Applescript file which pulls this repo and source .zshrc to apply any new settings. To enable running the syncing script on iTerm launch, you will need to create an AutoLaunch directory inside iTerm's Scripts directory:
``` shell
mkdir ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
```
### Starship
``` shell
brew install starship
```
### Neovim
``` shell
mkdir ~/.config/nvim/ && brew install neovim
```
### Nerd Font
You'll need at least one Nerd Font-compatible font installed to make NERDTree icons function. Your config may vary, but here's one to get started with:
``` shell
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
``` 
You can set the font in iTerm if using Neovim; for MacVim, you'll need to set the font in your .vimrc.
### Clone repo
Clone this repo into `$HOME` and create the following symlinks:
#### symlinks
``` shell
ln -s ~/dotfiles/vimrc ~/.vimrc # optional; only needed if you have a vanilla Vim config you want to sync
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/init.lua ~/.config/nvim/init.lua
ln -s ~/dotfiles/get_dotfiles.scpt ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
ln -s ~/dotfiles/config.el ~/.config/doom/config.el
```
