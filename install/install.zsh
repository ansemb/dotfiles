#!/bin/zsh

if [[ $EUID == 0 ]]; then
  echo "Do not run as root."
  exit
fi

OS="$(uname)"

# functions

# source common
source <(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/.config/zsh/common.zsh)

# PATHS
mkdir -p "$HOME/.local/bin"
pathappend "$HOME/.local/bin"


function install_neovim() {
  NVIM_BIN_DIR="$HOME/.local/bin"
  # remove previous
  [ -f "$NVIM_BIN_DIR/nvim" ] && rm "$NVIM_BIN_DIR/nvim" 

  curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --output "$NVIM_BIN_DIR/nvim"
  chmod u+x "$NVIM_BIN_DIR/nvim"
}

function install_rustup() {
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
}

function install_starship() {
  # install starship to .local/bin
  # TODO: allow startship to be installed in custom location
  # create directory for starship, it needs to exist
  curl -sS https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin"
}

function node_exists() {
  # if command -v pyenv 1>/dev/null 2>&1; then
  if type node > /dev/null; then
    return 1;
  fi
  return 0;
}

function pyenv_exists() {
  # if command -v pyenv 1>/dev/null 2>&1; then
  if type pyenv > /dev/null; then
    return 1;
  fi
  return 0;
}


function user_prompt_install_nvm() {
    # install nvm and node
  if node_exists; then
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
  fi
}

function user_prompt_nvm_install_node() {
  if ! type nvm > /dev/null; then
    echo "nvm not found. skipping node install..."
    return
  fi
  # prompt user for node installation
  read "continue?Install node? [Y/n] "
  echo ""
  if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
    echo "installing node (16)..."
    nvm install node 16
    nvm use 16
  fi
}

function install_pyenv() {
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
}

function user_prompt_install_pyenv() {
   # ask user to install pyenv 
  if pyenv_exists; then
    read "continue?Pyenv is not installed, install it? [Y/n] "
    echo ""

    if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
      install_pyenv
    fi
  fi
}

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
    get_python_version 'Invalid number. Try again (s to skip)'
  fi
}

function user_prompt_pyenv_install_python() {
  if ! pyenv_exists; then
    return;
  fi

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

  # install python version if not skipping
  if [[ "$py_version" != "0" ]]; then
    pyenv install "$py_version"
    pyenv global "$py_version"
  fi
}

function clean_prev_install_dotfiles() {
  # removing directory for clean install
  if [ -d "$DOTFILES_DIR" ]; then
    echo "dotfiles directory already in use: $DOTFILES_DIR"

    echo "Warning: deleting this will delete custom config"
    read "continue?This needs to be deleted to continue. Delete it? [Y/n] "
    echo ""

    if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
      rm -rf "$DOTFILES_DIR"
    else
      echo "exiting..."
      exit
    fi
  fi
}

function dotfiles_install() {
  echo "Installing dotfiles into dir: $HOME"
  if [ ! -f "$HOME/.gitignore" ] || ! grep -q ".dotfiles" "$HOME/.gitignore"; then
    echo ".dotfiles" >> "$HOME/.gitignore"
  fi

  git clone --bare https://github.com/ansemb/dotfiles.git $HOME/.dotfiles

  dotfiles checkout -f master
  dotfiles config --local status.showUntrackedFiles no
}


#########################################
# INSTALLATION
user_prompt_install_pyenv
user_prompt_pyenv_install_python

# check if python is installed
if ! type python3 > /dev/null; then
  echo "python is not installed. exiting..."
  exit
fi

install_neovim
install_rustup
install_starship
cargo install exa

user_prompt_install_nvm
user_prompt_nvm_install_node
user_prompt_install_lunarvim

# pynvim implements support for python plugins in Nvim
# python3 -m pip install --user --upgrade pip
# python3 -m pip install --user --upgrade wheel pynvim

user_prompt_install_lunarvim

# TODO: generate a paths file based on custom cargo/nvm/pyenv installations and include it


function user_prompt_install_lunarvim() {
  # install lunarvim (neovim config)
  read "continue?Install LunarVim? [Y/n] "
  echo ""
  if [[ "$continue" =~ ^[Yy]$ || "$continue" == "" ]]; then
    if ! node_exists; then
      echo "node does not exists. skipping install..."
    fi
    LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)
  fi
}


# install dotfiles
clean_prev_install_dotfiles

dotfiles_install

# cleanup
dotfiles-update-index

# run zsh shell to download zsh plugins
/bin/zsh -i -c exit

# change permissions for zinit directory
chmod -R 755 $HOME/.config/zsh/zinit


# change default shell
echo -e "\n\n"
echo "change default shell to zsh by running cmd below: (restart terminal afterwards)"
echo "chsh -s \$(which zsh)"
echo -e "\n"

