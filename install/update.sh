#!/bin/zsh

set -u

if [[ $EUID == 0 ]]; then
    echo "Do not run as root."
    exit
fi

# get home directory of user executing script
home_dir=$HOME
dotfiles_dir="$home_dir/.dotfiles"

# dotfiles function
function dotfiles {
	/usr/bin/git --git-dir="$dotfiles_dir/" --work-tree="$home_dir" "$@"
}


dotfiles fetch -q
if [[ $(dotfiles log -p HEAD..FETCH_HEAD | wc -l) -eq 0 ]]; then
	echo "No changes in dotfiles. Exiting..."
	exit
fi

echo "Changes detected on remote version."
read -p "Continue update (this will overwrite local changes)? [Y/n] " -n 1 -r
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
if [[ -d "$home_dir/install" ]]; then
	rmdir --ignore-fail-on-non-empty "$home_dir/install"
fi


echo "Finished update. Reload shell"
