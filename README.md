# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install  --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git zsh vim neovim file wget -y
```

Note: exa is currently in unstable release, so add the following to run following commands to add unstable repo:
```
sudo sh -c "echo '# 0 < P < 100: causes a version to be installed only if there is no installed version of the package\nPackage: *\nPin: release a=unstable\nPin-Priority: 50' > /etc/apt/preferences.d/unstable.pref"
sudo sh -c "echo 'deb http://http.us.debian.org/debian unstable main non-free contrib\ndeb-src http://http.us.debian.org/debian unstable main non-free contrib' > /etc/apt/sources.list.d/unstable.list"
```

add the public keys:
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
```
update system and install exa:
```
sudo apt update && sudo apt install exa -y
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
