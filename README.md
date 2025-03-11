# dotfiles

## Install guide

### (1) install packages on new system

#### On debian
```
sudo apt update && \
sudo apt install software-properties-common && \
sudo apt-add-repository -y ppa:fish-shell/release-3 && \
sudo add-apt-repository -y ppa:maveonair/helix-editor && \
sudo apt update && sudo apt upgrade -y && \
sudo apt install wget curl git zsh make cmake fish helix gpg fd-find -y && \
sudo apt install --no-install-recommends \
build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev \
libxmlsec1-dev libffi-dev liblzma-dev -y && \
sudo mkdir -p /etc/apt/keyrings && \
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list && \
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && \
sudo apt update && \
sudo apt install -y eza
```

- [starship](https://starship.rs/)
```bash
curl -sS https://starship.rs/install.sh | sh
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl git zsh vim neovim file wget xz tk
```

#### On mac
```bash
brew install eza cmake fish
brew install helix --HEAD
```

change shell
```bash
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
```

### (2) optional 
To install nvm/rust in custom directory
#### Set variables:
```
export NVM_DIR="/custom/installation/path/nvm"
export RUSTUP_HOME="/custom/installation/path/rustup"
export CARGO_HOME="/custom/installation/path/cargo"
```

### (3) run install script

Unix:
```
curl -sSf https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.zsh | zsh
```

WSL:
```
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.zsh | zsh
```

<br /><br /><br /><br />

### Other info

##### user specific settings can be set in:
```
$HOME/.config/zsh/user-settings.zsh
```

Links:
- [Rust install](https://www.rust-lang.org/tools/install)
- [LunarVim](https://www.lunarvim.org/)
