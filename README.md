# dotfiles

## Install guide

### (1) install packages on new system

#### On ubuntu
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y ppa:fish-shell/release-4
sudo add-apt-repository -y ppa:maveonair/helix-editor
sudo apt update
sudo apt install -y wget curl git make cmake fish helix gpg fd-find
sudo apt install -y --no-install-recommends \
  build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev

# eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

- [starship](https://starship.rs/)
```bash
curl -sS https://starship.rs/install.sh | sh
```


#### On debian
- [fish](https://software.opensuse.org/download.html?project=shells%3Afish%3Arelease%3A4&package=fish)
- [helix](https://github.com/helix-editor/helix/releases)
- [eza](https://eza.rocks/)
```bash
sudo apt update
sudo apt install -y gpg curl git
sudo apt install --no-install-recommends \
build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev \
libxmlsec1-dev libffi-dev liblzma-dev -y

# fish - debian 12
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:4.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null
sudo apt update
sudo apt install -y fish

# helix
wget https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb
sudo apt update
sudo apt install ./helix_25.7.1-1_amd64.deb
rm ./helix_25.7.1-1_amd64.deb

# eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl git fish file wget xz eza helix
```

#### On mac
```bash
brew install cmake fish eza helix
```

change shell
```bash
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
```

### (2) run install script

Unix (install with `deno`/`fnm`/`pnpm`):
```
curl -sSfH https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh | sh -s -- --all
```

Unix:
```
curl -sSfH https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh | sh
```

WSL:
```
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh | sh
```

- print help:
```
curl -sSfH https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh | sh -s -- --help
```

<br /><br /><br /><br />

### Other

[pyenv](https://github.com/pyenv/pyenv?tab=readme-ov-file#linuxunix):
``` bash
# linux
curl -fsSL https://pyenv.run | bash
```
```bash
# macos
brew update
brew install pyenv
```

[deno](https://deno.com/):
```bash
curl -fsSL https://deno.land/install.sh | sh
```

### Other info

##### user specific settings can be set in:
```
$HOME/.config/zsh/user-settings.zsh
```

Links:
- [Rust install](https://www.rust-lang.org/tools/install)
- [LunarVim](https://www.lunarvim.org/)
