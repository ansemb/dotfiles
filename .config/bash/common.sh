#!/usr/bin/env bash

# Converted from common.zsh to Bash (renamed functions with dashes to underscores).
set -euo pipefail

export CONFIG_HOME="${HOME}/.config"
export CACHEDIR="${HOME}/.cache"
export DOTFILES_DIR="${HOME}/.dotfiles"
export DOTFILES_REPO="https://raw.githubusercontent.com/ansemb/dotfiles/HEAD"

pathappend() {
  for ARG in "$@"; do
    if [[ -d "${ARG}" && ":$PATH:" != *":${ARG}:"* ]]; then
      PATH="${PATH:+"$PATH:"}${ARG}"
    fi
  done
}

pathprepend() {
  for ARG in "$@"; do
    if [[ -d "${ARG}" && ":$PATH:" != *":${ARG}:"* ]]; then
      PATH="${ARG}${PATH:+":$PATH"}"
    fi
  done
}

dotfiles() {
  /usr/bin/git --git-dir="${DOTFILES_DIR}/" --work-tree="${HOME}" "$@"
}

dotfiles_update() {
  bash -c "$(curl -fsSL ${DOTFILES_REPO}/install/update.sh)"
}

dotfiles_update_index() {
  local readme_file="${HOME}/README.md"
  dotfiles update-index --assume-unchanged "${readme_file}" || true
  if [[ -f "${readme_file}" ]]; then
    rm -f "${readme_file}"
  fi
  while IFS= read -r filename; do
    [[ -z "${filename}" ]] && continue
    echo "dotfiles, ignoring file: ${filename}"
    dotfiles update-index --assume-unchanged "${filename}" || true
    if [[ -f "${HOME}/${filename}" ]]; then
      echo "dotfiles, removing file: ${filename}"
      rm -f "${HOME}/${filename}"
    fi
  done < <(dotfiles ls-files "${HOME}/install" || true)
  if [[ -d "${HOME}/install" ]]; then
    echo "dotfiles, removing install directory if empty."
    rmdir "${HOME}/install" >/dev/null 2>&1 || true
  fi
  dotfiles update-index --skip-worktree "${ZDOTDIR:-$HOME/.config/zsh}/user-settings.zsh" || true
}
