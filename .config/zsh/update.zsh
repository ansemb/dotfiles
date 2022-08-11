#!/bin/zsh

last_login_dir="$ZCACHEDIR"
last_login_path="$last_login_dir/.last_login"
cur_date="$(date '+%Y%m')"

[ -d "$last_login_dir" ] || mkdir "$last_login_dir"

# if no file exists, create one
if [[ ! -f "$last_login_path" ]]; then
  echo "$cur_date" > "$last_login_path"
  return 0
fi


last_login=$(head -n 1 "$last_login_path")

# update if new month
if [[ cur_date -gt last_login ]]; then
  echo "dotfiles checking for update..."
  dotfiles-update
fi

# update tmp file
echo "$cur_date" > "$last_login_path"
