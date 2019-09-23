# dotfiles

### First time setup
create a git bare repo

```
git init --bare $HOME/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
echo "alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'" >> $HOME/.config/.aliases
```
now add/commit/push files to the dotfiles repo like:
```
dotfiles add ~/.config/.aliases
dotfiles commit -m "message"
dotfiles push
```

### Install
install my required packages

#### On debian
```
sudo apt install vim neovim curl python3 python3-pip tmux zsh git wget
```

#### On arch
```
sudo pacman -S vim neovim curl python3 python3-pip tmux zsh git wget
```
