# dotfiles

## Install guide

### (1) install packages on new system

#### On debian
```
sudo apt update && sudo apt upgrade -y && sudo apt install --no-install-recommends wget curl git zsh vim make build-essential libffi-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev  -y
```

#### On arch
```
sudo pacman -S base-devel openssl zlib curl git zsh vim neovim file wget exa xz tk
```

#### On mac
```
brew install exa wget neovim
```

### (2) install rust

#### WSL:
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

#### Unix:
```
curl https://sh.rustup.rs -sSf | sh
```

### (3) run install script

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh)"
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
