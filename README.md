# dotfiles

## First time setup
create a git bare repo
```
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.config/.aliases
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

remove/ignore README.md from local repo
```
dotfiles config core.sparsecheckout true
echo '/*' >> ~/.dotfiles/info/sparse-checkout
echo '!README.md' >> ~/.dotfiles/info/sparse-checkout
rm README.md
dotfiles checkout
```


### Install packages on new system
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

#### clone oh-my-zsh to .config/zsh dir add syntax higlighting
```
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.config/zsh/.oh-my-zsh
```
#### add some plugins to oh-my-zsh
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
#### theming
```
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```
