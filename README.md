# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install make build-essential wget curl tk-dev git zsh vim -y
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl git zsh vim neovim file wget exa xz tk
```

#### On mac
```
brew install exa wget neovim
```

### Run Install script
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh)"
```

##### User specific settings can be set in:
```
$HOME/.config/zsh/user-settings.zsh
```
