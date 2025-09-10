#!/usr/bin/env bash

set -euo pipefail

if [[ ${EUID} == 0 ]]; then
  echo "Do not run as root."
  exit 1
fi

# shellcheck disable=SC1090
source "${HOME}/.config/bash/common.sh"

dotfiles fetch -q
if [[ $(dotfiles log -p HEAD..FETCH_HEAD | wc -l) -eq 0 ]]; then
  echo "No changes in dotfiles. Exiting..."
  exit 0
fi

echo "Changes detected on remote version."
read -r -p "Continue update? [Y/n] " continue_ans || true
echo ""
if [[ ${continue_ans:-Y} =~ ^[Nn]$ ]]; then
  echo "exiting..."
  exit 0
fi

dotfiles pull
dotfiles config --local status.showUntrackedFiles no

if command -v dotfiles_update_index >/dev/null 2>&1; then
  dotfiles_update_index
else
  echo "Warning: dotfiles_update_index function not found (skipping)." >&2
fi

echo "Finished update. Reload shell"
