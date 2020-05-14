# dotfiles

## First time setup
create a git bare repo
```
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.config/.aliases
dotfiles config --local status.showUntrackedFiles no
```
now add/commit/push files to the dotfiles repo like:
```
dotfiles add ~/.config/.aliases
dotfiles commit -m "message"
dotfiles push
```
add modified/deleted files
```
git add -u
```

## Install existing dotfiles on a new system
ignore the dotfiles repo
```
echo ".dotfiles" >> .gitignore
```
clone dotfiles into a bare repository:
```
git clone --bare <git-repo-url> $HOME/.dotfiles
```
define alias in the current shell scope
```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
checkout the actual content from the bare repository to your $HOME (if error, probably from setting the dotfiles on the same computer; remove the listed files and checkout again:
```
dotfiles checkout
```
set the flag showUntrackedFiles to 'no' on this specific (local) repository:
```
dotfiles config --local status.showUntrackedFiles no
```

ignore README.md from local repo
```
git update-index --assume-unchanged $HOME/README.md
rm $HOME/README.md
```

### Install packages on new system
install some packages

#### On debian
```
sudo apt install vim neovim curl wget zsh git cargo
cargo install exa
```

#### On arch
```
sudo pacman -S vim neovim curl wget zsh git cargo
cargo install exa
```

#### set zsh as default shell
```
chsh -s $(which zsh)
```

#### WSL
```
chmod -R 755 $HOME/.config/zsh/zplugin
```
