# dotfiles

## Install guide

### First install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install  --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git zsh vim neovim file wget exa -y
```

Note: exa is currently in unstable release, so add the following to /etc/apt/preferences.d/unstable.pref:
```
# 0 < P < 100: causes a version to be installed only if there is no installed version of the package
Package: *
Pin: release a=unstable
Pin-Priority: 50
```

and add to /etc/apt/sources.list.d/unstable.list:
```
# Unstable repo main, contrib and non-free branches, no security updates here
deb http://http.us.debian.org/debian unstable main non-free contrib
deb-src http://http.us.debian.org/debian unstable main non-free contrib
```
add the public keys:
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
```
update system and install exa:
```
sudo apt update && sudo apt install exa
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl git zsh vim neovim file wget exa xz tk
```

### Run Install script
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh)"
```
