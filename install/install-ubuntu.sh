#!/bin/bash
set -u

if [[ $EUID > 0 ]]; then
    echo "Please run as root."
    exit
fi

# ubuntu upgrade packages and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential curl python3 git zsh vim neovim file wget 

# for nvim python packages
python3 -m pip install -U pip
python3 -m pip install --user --upgrade pynvim

# brew install (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
brew install exa


# get hoome directory of user executing script
home_dir=$(/bin/bash -c "eval echo ~$SUDO_USER")
echo "Installing dotfiles into dir: $home_dir"

echo ".dotfiles" >> "$home_dir/.gitignore"

git clone --bare https://github.com/ansemb/dotfiles.git $home_dir/.dotfiles

alias dotfiles='/usr/bin/git --git-dir=$home_dir/.dotfiles/ --work-tree=$home_dir'

dotfiles checkout -f master
dotfiles config --local status.showUntrackedFiles no

# ignore readme
dotfiles update-index --assume-unchanged "$home_dir/README.md"
rm "$home_dir/README.md"

# ignore install directory
dotfiles update-index --assume-unchanged "$home_dir/install"
rm -rf "$home_dir/install"


# change shell to zsh
chsh -s $(which zsh)
zsh

# change permissions for zinit directory
chmod -R 755 $home_dir/.config/zsh/zinit
