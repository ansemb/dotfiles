#!/bin/bash
set -u

if [[ $EUID == 0 ]]; then
    echo "Do not run as root."
    exit
fi

# functions

pathadd() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
       PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

# brew install
if ! type brew >/dev/null 2>&1; then
    echo "installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "updating brew..."
    brew update
fi

brew_global_install_path="/home/linuxbrew/.linuxbrew"
brew_local_install_path="$HOME/.linuxbrew"

if [ ! -f "$brew_global_install_path/bin/brew" ] && [ ! -f "$brew_local_install_path/bin/brew" ]; then
    echo "brew not installed. exiting..."
    exit
fi

pathadd "$brew_global_install_path/bin" "$brew_local_install_path/bin"
brew install gcc pyenv

# setup pyenv with latest python version
export PYENV_ROOT="$HOME/.pyenv"
pathadd "$PYENV_ROOT/bin"

# pyenv init
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# get latest python version
latest_py=$(pyenv install --list | grep -P "^\s*(\d|\.)+\s*$" | tail -1 | xargs)
# install python version
pyenv install "$latest_py"
pyenv global "$latest_py"

# for nvim python packages
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade wheel pynvim neovim 

# nvm install
export NVM_DIR="$HOME/.config/nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "installing nvm..."
    mkdir -p $NVM_DIR
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh NVM_DIR="$HOME/.config/nvm" | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    echo "done."
fi
# install node (needed for coc.nvim)
echo "installing node..."
nvm install node

# get home directory of user executing script
home_dir=$HOME
dotfiles_dir="$home_dir/.dotfiles"
echo "Installing dotfiles into dir: $home_dir"
# removing directory for clean install
[ -d "$dotfiles_dir" ] && rm -rf "$dotfiles_dir"

if [ ! -f "$home_dir/.gitignore" ] || ! grep -q ".dotfiles" "$home_dir/.gitignore"; then
    echo ".dotfiles" >> "$home_dir/.gitignore"
fi

git clone --bare https://github.com/ansemb/dotfiles.git $home_dir/.dotfiles

shopt -s expand_aliases
alias dotfiles='/usr/bin/git --git-dir=$dotfiles_dir/ --work-tree=$home_dir'

dotfiles checkout -f master
dotfiles config --local status.showUntrackedFiles no

# ignore readme
dotfiles update-index --assume-unchanged "$home_dir/README.md"
rm "$home_dir/README.md"

# ignore install directory
for filename in "$home_dir/install"/*; do
        dotfiles update-index --assume-unchanged "$filename"
done
dotfiles update-index --assume-unchanged "$home_dir/install/"
rm -rf "$home_dir/install"


# run zsh shell to download zsh plugins
/bin/zsh -i -c exit

# change permissions for zinit directory
chmod -R 755 $home_dir/.config/zsh/zinit

# change default shell
echo -e "\n"
echo "changing default shell to zsh, please input password"
chsh -s $(which zsh)
echo "restart shell or run zsh command"
