#!/bin/zsh

if [[ $EUID == 0 ]]; then
  echo "Do not run as root."
  exit
fi

OS="$(uname)"

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
  elif [[ " ${PY_VERSIONS[*]} " == *" ${number} "* ]]; then
    py_version="$number"
  else
    get_python_version 'Invalid number. Try again (q to quit/s to skip)'
  fi
}

# INSTALLATION

# ask user to install pyenv 
if ! type pyenv > /dev/null; then
  read "continue?Pyenv is not installed, install it? [Y/n] "
  echo ""
  
  if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
    echo "Installing pyenv to: $HOME/.pyenv"
    if [[ "${OS}" == "Linux" ]]
    then
      # TODO: allow for custom installation path of pyenv
      git clone https://github.com/pyenv/pyenv.git ~/.pyenv
      cd ~/.pyenv && src/configure && make -C src
    elif [[ "${OS}" == "Darwin" ]]
    then
      brew update
      brew install pyenv
      
      # set CC flag: https://github.com/pyenv/pyenv/issues/2159#issuecomment-983960026
      # CC="$(brew --prefix gcc)/bin/gcc-11"
    fi
  fi
fi

# install latest/ a specific python version with pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  # pyenv init
  eval "$(pyenv init --path)"
  # get latest python version
  latest_py=$(pyenv install --list | perl -nle "print if m{^\s*(\d|\.)+\s*$}" | tail -1 | xargs)

  echo ""
  echo "Pyenv found latest python version: $latest_py"
  py_version="$latest_py"

  read "continue?Install this python version? [Y/n] "
  echo ""

  if [[ "$continue" =~ ^[Nn]$ ]]; then
    PY_VERSIONS=("${(@f)$(pyenv install --list  | perl -nle 'print if m{^\s*3\.(\d|\.)+\s*$}' | sed 's/\s*//')}")
    echo 'Available python versions:'
    printf '%s\n' "${PY_VERSIONS[@]}"

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
  echo "nodejs not found."
  
  if ! (( ${+NVM_DIR} )); then
    export NVM_DIR="$HOME/.config/nvm"
  fi
  if [ ! -d "$NVM_DIR" ]; then
    read "continue?Install nvm (for NodeJS installation)? [Y/n] "
    echo ""
    if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
      echo "installing nvm..."
      mkdir -p $NVM_DIR
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
      echo "done."
    fi
  fi
  # load nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  if ! type nvm > /dev/null; then
    # prompt user for node installation
    read "continue?Install node? [Y/n] "
    echo ""
    if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
      echo "installing node..."
      nvm install node
    fi
  fi
fi

# install rust/cargo
if ! type cargo > /dev/null; then
  if ! (( ${+CARGO_HOME} )); then
    export CARGO_HOME="$HOME/.cargo"
  fi
  if grep -q "microsoft" /proc/sys/kernel/osrelease; then
    # we are in WSL
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  else
    # linux/darwin
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
  fi
  # load cargo
  [ -f "$CARGO_HOME/env" ] && \. "$CARGO_HOME/env"
fi
# TODO: isntall exa with cargo?: cargo install exa
# TODO: generate a paths file based on custom cargo/nvm/pyenv installations and include it

# pynvim implements support for python plugins in Nvim
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade wheel pynvim

# install lunarvim (neovim config)
read "continue?Install LunarVim? [Y/n] "
echo ""
if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
  LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)
fi

# install starship to .local/bin
# TODO: allow startship to be installed in custom location
# create directory for starship, it needs to exist
mkdir -p "$HOME/.local/bin"
curl -sS https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin"

# install dotfiles
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
