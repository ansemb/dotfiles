#!/bin/bash
set -u

if [[ $EUID == 0 ]]; then
    echo "Do not run as root."
    exit
fi


# for nvim python packages
python3 -m pip install -U pip
python3 -m pip install --user --upgrade pynvim

# brew install (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ ! -d "/home/linuxbrew/.linuxbrew" ] && [ ! -d "$HOME/.linuxbrew" ]; then
    echo "brew not installed. exiting..."
    exit
fi

export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$HOME/.linuxbrew"
brew install gcc exa

# nvm install
export NVM_DIR="$HOME/.config/nvm"
mkdir $NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh NVM_DIR="$HOME/.config/nvm" | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# install node
nvm install node

# get home directory of user executing script
home_dir=$HOME
dotfiles_dir="$home_dir/.dotfiles"
echo "Installing dotfiles into dir: $home_dir"
[ -d "$dotfiles_dir" ] && rm -rf "$dotfiles_dir"

echo ".dotfiles" >> "$home_dir/.gitignore"

git clone --bare https://github.com/ansemb/dotfiles.git $home_dir/.dotfiles

shopt -s expand_aliases
alias dotfiles='/usr/bin/git --git-dir=$dotfiles_dir/ --work-tree=$home_dir'

dotfiles checkout -f master
dotfiles config --local status.showUntrackedFiles no

# ignore readme
dotfiles update-index --assume-unchanged "$home_dir/README.md"
rm "$home_dir/README.md"

# ignore install directory
for filename in "$home_dir/install"/*; do
        dotfiles update-index --assume-unchanged "$filename"
done
dotfiles update-index --assume-unchanged "$home_dir/install/"
rm -rf "$home_dir/install"


# change shell to zsh
/bin/zsh -i -c exit

# change permissions for zinit directory
chmod -R 755 $home_dir/.config/zsh/zinit

# change default shell
echo -e "\n"
echo "changing default shell to zsh, please input password"
chsh -s $(which zsh)
echo "restart shell or run zsh command"
