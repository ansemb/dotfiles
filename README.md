# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install  --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl python3 python3-pip git zsh vim neovim file wget -y
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl python3 python3-pip git zsh vim neovim file wget xz
```

### Run Install script
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh)"
```
