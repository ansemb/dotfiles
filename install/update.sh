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

dotfiles fetch
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
dotfiles update-index --assume-unchanged "$home_dir/README.md"

if [[ -f "$home_dir/README.mb" ]]; then
	rm "$home_dir/README.md"
fi

# ignore install directory files
for filename in "$(dotfiles ls-files "$home_dir/install")"; do
	dotfiles update-index --assume-unchanged "$filename"
	if [[ -f "$filename" ]]; then
		rm "$filename"
	fi
done


# do cleanup
if [[ -d "$home_dir/install" ]]; then
	# prompt user to remove install directory; user might have files in this directory
	read -p "Remove directory '$home_dir/install' completely (used for install files, but if directory is already used by you, answer no) (Y/n)? " -n 1 -r
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
		echo "Removing '$home_dir/install'"
		rm -rf "$home_dir/install"
	fi
fi

echo "Finished update. Reloading shell"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto"
reload