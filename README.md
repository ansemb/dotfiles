# dotfiles

### First time setup
create a git bare repo

```
git init --bare $HOME/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
echo "alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'" >> $HOME/.config/.aliases
dotfiles config --local status.showUntrackedFiles no
```
now add/commit/push files to the dotfiles repo like:
```
dotfiles add ~/.config/.aliases
dotfiles commit -m "message"
dotfiles push
```

### Install
install some packages

#### On debian
```
sudo apt install vim neovim curl wget zsh git fonts-powerline
```

#### On arch
```
sudo pacman -S vim neovim curl wget zsh git fonts-powerline
```

#### set zsh as default shell
```
chsh -s $(which zsh)
```

#### clone oh-my-zsh to .config/zsh dir
```
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.config/zsh/.oh-my-zsh
```
