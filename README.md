# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install build-essential curl python3 python3-pip git zsh vim neovim file wget -y
```

#### On arch
```
sudo pacman -S curl python3 python3-pip git zsh vim neovim file wget
```

### Run Install script
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh)"
```
