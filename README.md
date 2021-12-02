# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install --no-install-recommends wget curl git zsh vim cargo make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev  -y
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
