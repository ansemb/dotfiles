#!/bin/zsh

if [[ $EUID == 0 ]]; then
  echo "Do not run as root."
  exit
fi

# functions

# source common
source <(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/.config/zsh/common.zsh)

# function to get python version number from user
function get_python_version() {
  read "number?${1}: "
  if [[ "$number" == "q" ]]; then
    py_version=-1;
  elif [[ "$number" == "s" ]]; then
    py_version=0;
  elif [[ " ${py_versions[*]} " == *" ${number} "* ]]; then
    py_version="$number"
  else
    get_python_version 'Invalid number. Try again (q to quit/s to skip)'
  fi
}


# brew install
if ! which brew >/dev/null 2>&1; then
  read "continue?Brew is not installed, install it? [Y/n] "
  
  if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
    echo "installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
else
  echo "updating brew..."
  brew update
fi

brew_global_install_path="/home/linuxbrew/.linuxbrew"
brew_local_install_path="$HOME/.linuxbrew"
brew_mac_arm64="/opt/homebrew"
brew_mac_intel="/usr/local/Homebrew"

if type brew > /dev/null; then
  pathappend "$brew_global_install_path/bin" "$brew_local_install_path/bin" "$brew_mac_arm64/bin" "$brew_mac_intel/bin"
  brew install gcc pyenv starship
  # install latest version of neovim
  brew install --HEAD luajit
  brew install --HEAD neovim

  # set CC flag: https://github.com/pyenv/pyenv/issues/2159#issuecomment-983960026
  CC="$(brew --prefix gcc)/bin/gcc-11"
fi

# pyenv init
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  # get latest python version
  latest_py=$(pyenv install --list | perl -nle "print if m{^\s*(\d|\.)+\s*$}" | tail -1 | xargs)

  echo ""
  echo "Pyenv found latest python version: $latest_py"
  py_version="$latest_py"

  read "continue?Install this python version? [Y/n] "
  echo ""

  if [[ "$continue" =~ ^[Nn]$ ]]; then
    py_versions=("${(@f)$(pyenv install --list  | perl -nle 'print if m{^\s*3\.(\d|\.)+\s*$}' | sed 's/\s*//')}")
    echo 'Available python versions:'
    printf '%s\n' "${py_versions[@]}"

    get_python_version 'Select version to install (q to quit/s to skip)'
  fi

  # if we found a python version, continue
  if [[ "$py_version" == "-1" ]]; then
    echo ""
    echo "exiting..."
    exit
  fi

  # install python version if not skipping
  if [[ "$py_version" != "0" ]]; then
    pyenv install "$py_version"
    pyenv global "$py_version"
  fi
fi

# check if python is installed
if ! type python3 > /dev/null; then
  echo "python is not installed. exiting..."
  exit
fi

# install nvm and node
if ! type node > /dev/null; then
  export NVM_DIR="$HOME/.config/nvm"
  if [ ! -d "$NVM_DIR" ]; then
    echo "installing nvm..."
    mkdir -p $NVM_DIR
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh NVM_DIR="$HOME/.config/nvm" | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    echo "done."
  fi

  # install node
  echo "installing node..."
  nvm install node
fi

# install rust/cargo
if ! type cargo > /dev/null; then
  if grep -q "microsoft" /proc/sys/kernel/osrelease; then
    # we are in WSL
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  else
    # linux/darwin
    curl https://sh.rustup.rs -sSf | sh
  fi
  # load cargo
  [ -f "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"
fi


# pynvim implements support for python plugins in Nvim
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade wheel pynvim

# install lunarvim (neovim config)
LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)

# install dotfiles
if ! type cargo > /dev/null; then
echo "Installing dotfiles into dir: $HOME"

# removing directory for clean install

if [ -d "$DOTFILES_DIR" ]; then
  echo "dotfiles directory already in use: $DOTFILES_DIR"

  read "continue?This needs to be deleted to continue. Delete it? [Y/n] "
  echo ""

  if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
    rm -rf "$DOTFILES_DIR"
  else
    echo "exiting..."
    exit
  fi
fi

if [ ! -f "$HOME/.gitignore" ] || ! grep -q ".dotfiles" "$HOME/.gitignore"; then
    echo ".dotfiles" >> "$HOME/.gitignore"
fi

git clone --bare https://github.com/ansemb/dotfiles.git $HOME/.dotfiles

dotfiles checkout -f master
dotfiles config --local status.showUntrackedFiles no

# cleanup
dotfiles-update-index

# run zsh shell to download zsh plugins
/bin/zsh -i -c exit

# change permissions for zinit directory
chmod -R 755 $HOME/.config/zsh/zinit


# change default shell
echo -e "\n"
echo "changing default shell to zsh, please input password"
chsh -s $(which zsh)
echo "restart shell or run zsh command"
