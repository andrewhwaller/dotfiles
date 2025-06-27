# dotfiles
it's vim time, bb

Includes config files for [fish](https://fishshell.com/), [kitty](https://sw.kovidgoyal.net/kitty/), [Starship](https://starship.rs/), [Neovim](https://neovim.io/), [opencode](https://opencode.ai/), and Doom (just for org-mode, tho).
## Installation
### fish
``` shell
brew install fish
```
### Starship
``` shell
brew install starship
```
### Neovim
``` shell
mkdir ~/.config/nvim/ && brew install neovim
```
### opencode
``` shell
brew install sst/tap/opencode
```
### Nerd Font
You'll need at least one Nerd Font-compatible font installed to make NERDTree icons function. Your config may vary, but here's one to get started with:
``` shell
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
``` 
### Clone repo
Clone this repo into `$HOME` and create the following symlinks:
#### symlinks

``` shell
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -s ~/dotfiles/nvim/lua ~/.config/nvim/lua
ln -s ~/dotfiles/doom/config.el ~/.config/doom/config.el
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/gh-dash ~/.config/gh-dash
ln -s ~/dotfiles/ghostty ~/.config/ghostty
ln -s ~/dotfiles/opencode ~/.config/opencode

# Linux only
ln -s ~/dotfiles/hypr ~/.config/hypr
```
