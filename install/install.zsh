#!/bin/zsh

if [[ $EUID == 0 ]]; then
  echo "Do not run as root."
  exit
fi

OS="$(uname)"

# source common
source <(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/.config/zsh/common.zsh)

# PATHS
mkdir -p "$HOME/.local/bin"
pathappend "$HOME/.local/bin"
  
if ! (( ${+NVM_DIR} )); then
  NVM_DIR="$HOME/.config/nvm"
fi
export NVM_DIR
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! (( ${+PYENV_ROOT} )); then
  PYENV_ROOT="$HOME/.config/pyenv"
fi
export PYENV_ROOT
pathappend "$PYENV_ROOT/bin"

if ! (( ${+RUSTUP_HOME} )); then
  RUSTUP_HOME="$HOME/.config/rustup"
fi
export RUSTUP_HOME

if ! (( ${+CARGO_HOME} )); then
  CARGO_HOME="$HOME/.config/cargo"
fi
export CARGO_HOME
pathappend "$CARGO_HOME/bin"
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"


# FUNCTIONS

function node_exists() {
  type node &> /dev/null
}

function nvm_exists() {
  type nvm &> /dev/null
}

function pyenv_exists() {
  # if command -v pyenv 1>/dev/null 2>&1; then
  type pyenv &> /dev/null
}

function install_neovim() {
  NVIM_BIN_DIR="$HOME/.local/bin"
  # remove previous
  [ -f "$NVIM_BIN_DIR/nvim" ] && rm "$NVIM_BIN_DIR/nvim" 

  curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --output "$NVIM_BIN_DIR/nvim"
  chmod u+x "$NVIM_BIN_DIR/nvim"
}

function install_rustup() {
  # install rust/cargo
  if type rustup &> /dev/null; then
    echo "rustup is already installed. skipping installation..."
    return
  fi
  
  echo "rustup not found."
  echo "installing rustup to: $RUSTUP_HOME"
  
  if grep -q "microsoft" /proc/sys/kernel/osrelease; then
    # we are in WSL
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  else
    # linux/darwin
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
  fi
  # load cargo
  pathappend "$CARGO_HOME/bin"
  [ -f "$CARGO_HOME/env" ] && \. "$CARGO_HOME/env"

  rustup default stable
  echo -e "\n"
} 

function install_nvm() {
  # don't install node if it exists
  if nvm_exists; then
    echo "nvm already exists. skipping installation..."
    return
  fi

  # install nvm and node
  echo "nvm not found."
  echo "installing nvm to: $NVM_DIR"
  mkdir -p $NVM_DIR
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  echo "done."

  # load nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  echo -e "\n"
}

function nvm_install_node() {
  if ! nvm_exists; then
    echo "nvm not found. this is required..."
    return
  fi
  if node_exists; then
    echo "node already exists. skipping installation..."
    return
  fi

  echo "installing node..."
  nvm install --lts
  nvm use --lts
  nvm alias default "lts/*"
  echo -e "\n"
}

function install_pyenv() {
  # ask user to install pyenv 
  if pyenv_exists; then
    echo "pyenv already exists. skipping installation..."
    return
  fi
  
  echo "pyenv not found."
  
  if [[ "${OS}" == "Linux" ]]; then
    echo "installing pyenv to: $PYENV_ROOT"
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
    pushd "$PYENV_ROOT" && src/configure && make -C src && popd

    pathappend "$PYENV_ROOT/bin"

    # pyenv init
    eval "$(pyenv init -)"
  elif [[ "${OS}" == "Darwin" ]]; then
    brew update
    brew install pyenv

    # set CC flag: https://github.com/pyenv/pyenv/issues/2159#issuecomment-983960026
    # CC="$(brew --prefix gcc)/bin/gcc-11"
  fi
  echo -e "\n"
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
    get_python_version 'Invalid number. Try again (s to skip/q to quit)'
  fi
}

function user_prompt_require_pyenv_install_python() {
  if ! pyenv_exists; then
    echo "pyenv does not exist. exiting..."
    exit
  fi

  eval "$(pyenv init -)"
 
  if [[ $(pyenv global) ]] &> /dev/null; then
    echo "python version found with pyenv. skipping python installation..."
    return
  fi
  
  # get latest python version
  latest_py=$(pyenv install --list | perl -nle "print if m{^\s*(\d|\.)+\s*$}" | tail -1 | xargs)

  echo ""
  
  echo "No python version is installed from pyenv. This is required."
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
  if [[ "$py_version" == "-1" ]]; then
    echo ""
    echo "exiting..."
    exit
  fi

  echo -e "\n"
}

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
install_pyenv
user_prompt_require_pyenv_install_python

install_neovim
install_rustup

cargo install starship
cargo install exa

install_nvm
nvm_install_node

user_prompt_install_lunarvim

# TODO: generate a paths file based on custom cargo/nvm/pyenv installations and include it


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

