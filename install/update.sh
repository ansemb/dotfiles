#!/bin/bash
set -u

if [[ $EUID == 0 ]]; then
    echo "Do not run as root."
    exit
fi

# get home directory of user executing script
home_dir=$HOME
dotfiles_dir="$home_dir/.dotfiles"

shopt -s expand_aliases
alias dotfiles='/usr/bin/git --git-dir=$dotfiles_dir/ --work-tree=$home_dir'

dotfiles fetch -q
if [[ $(dotfiles log -p HEAD..FETCH_HEAD | wc -l) -eq 0 ]]; then
	echo "No changes. Exiting..."
	exit
fi

read -p "Changes detected on remote version. Continue update (this will overwrite local changes) (Y/n)? " -n 1 -r
echo ""
if [[ "$REPLY" =~ ^[Nn]$ ]]; then
	echo "exiting..."
	exit
fi

dotfiles pull --force
dotfiles config --local status.showUntrackedFiles no

# ignore readme
readme_file="$home_dir/README.md"
dotfiles update-index --assume-unchanged "$readme_file"

if [[ -f "$readme_file" ]]; then
	rm "$readme_file"
fi

# ignore and remove install directory files
while IFS= read -r filename; do
	echo "dotfiles, ignoring file: $filename"
	dotfiles update-index --assume-unchanged "$filename"
	if [[ -f "$filename" ]]; then
		rm "$filename"
	fi
done < <(dotfiles ls-files "$home_dir/install")

# do cleanup
rmdir --ignore-fail-on-non-empty "$home_dir/install"


echo "Finished update. Reloading shell"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto"
reload
