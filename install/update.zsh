#!/bin/zsh

set -u

if [[ $EUID == 0 ]]; then
    echo "Do not run as root."
    exit
fi

# source common
source <(curl -fsSL "https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/.config/zsh/common.zsh")

dotfiles fetch -q
if [[ $(dotfiles log -p HEAD..FETCH_HEAD | wc -l) -eq 0 ]]; then
	echo "No changes in dotfiles. Exiting..."
	exit
fi

echo "Changes detected on remote version."
read "continue?Continue update? [Y/n] "
echo ""
if [[ "$continue" =~ ^[Nn]$ ]]; then
	echo "exiting..."
	exit
fi

dotfiles pull
dotfiles config --local status.showUntrackedFiles no

dotfiles-update-index


echo "Finished update. Reload shell"
