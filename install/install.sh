#!/usr/bin/env sh

# POSIX mode: -e (exit on error), -u (unset var error). 'pipefail' is not POSIX.
set -eu

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run as root." >&2
  exit 1
fi

OS="$(uname)"

# VARIABLES
export CONFIG_HOME="${HOME}/.config"
export CACHEDIR="${HOME}/.cache"

# DOTFILES
export DOTFILES_DIR="${HOME}/.dotfiles"
export DOTFILES_REPO="https://raw.githubusercontent.com/ansemb/dotfiles/HEAD"

# PATH HELPERS
pathappend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ]; then
      case ":$PATH:" in
        *:"$ARG":*) ;;
        *) PATH="${PATH:+$PATH:}$ARG" ;;
      esac
    fi
  done
}


mkdir -p "${HOME}/.local/bin"
pathappend "${HOME}/.local/bin"


if [ -z "${RUSTUP_HOME+x}" ]; then
  RUSTUP_HOME="${HOME}/.rustup"
fi
export RUSTUP_HOME

if [ -z "${CARGO_HOME+x}" ]; then
  CARGO_HOME="${HOME}/.cargo"
fi
export CARGO_HOME
pathappend "${CARGO_HOME}/bin"
[ -f "${CARGO_HOME}/env" ] && . "${CARGO_HOME}/env"

# FUNCTIONS
is_env_wsl() {
  grep -qi "microsoft" /proc/sys/kernel/osrelease 2>/dev/null
}

install_zoxide() {
  if command -v zoxide >/dev/null 2>&1; then
    echo "zoxide already installed; skipping."
    echo
    return 0
  fi

  echo installing zoxide...

  if is_env_wsl; then
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s
  else
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi
  echo
}

install_starship() {
  echo installing starship...
  # install starship prompt
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo
}

install_pnpm() {
  echo installing pnpm...
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  echo
}

install_fnm() {
  echo installing fnm...
  curl -fsSL https://fnm.vercel.app/install | bash
  echo
}

install_deno() {
  echo installing deno...
  curl -fsSL https://deno.land/install.sh | sh -s -- --yes --no-modify-path
  echo
}

install_fisher() {
  echo "installing fisher..."
  if ! command -v fish >/dev/null 2>&1; then
    echo "Error: fish is not installed. Please install fish first." >&2
    return 1
  fi

  fish -c '
    curl -sL \
      https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
      | source
    and fisher install jorgebucaran/fisher
  '  </dev/null
}

install_rustup() {
  echo installing rustup...
  if command -v rustup >/dev/null 2>&1; then
    echo "rustup is already installed. skipping installation..."
    return
  fi

  echo "rustup not found."
  echo "installing rustup to: ${RUSTUP_HOME}"
  if is_env_wsl; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  else
    curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  fi
  pathappend "${CARGO_HOME}/bin"
  [ -f "${CARGO_HOME}/env" ] && . "${CARGO_HOME}/env"
  rustup default stable || true
  echo
}

#########################################
# DOTFILES

clean_prev_install_dotfiles() {
  if [ -d "${DOTFILES_DIR}" ]; then
    echo "dotfiles directory already in use: ${DOTFILES_DIR}"
    echo "Warning: deleting this will delete custom config"
    ans=""

    printf '%s' "This needs to be deleted to continue. Delete it? [Y/n] "
    read -r ans </dev/tty

    echo
    case "${ans:-Y}" in
      [Yy]*)
        rm -rf "${DOTFILES_DIR}" ;;
      *)
        echo "exiting..."; exit 0 ;;
    esac
  fi
}

dotfiles() {
  /usr/bin/git --git-dir="${DOTFILES_DIR}/" --work-tree="${HOME}" "$@"
}

dotfiles_install() {
  echo "Installing dotfiles into dir: ${HOME}"
  if [ ! -f "${HOME}/.gitignore" ] || ! grep -q ".dotfiles" "${HOME}/.gitignore"; then
    echo ".dotfiles" >> "${HOME}/.gitignore"
  fi
  git clone --bare https://github.com/ansemb/dotfiles.git "${HOME}/.dotfiles"
  dotfiles checkout -f master
  dotfiles config --local status.showUntrackedFiles no
}

dotfiles_update_index() {
  readme_file="${HOME}/README.md"
  dotfiles update-index --assume-unchanged "${readme_file}" || true
  if [ -f "${readme_file}" ]; then
    rm -f "${readme_file}"
  fi
  bootstrap_file="${HOME}/bootstrap.sh"
  dotfiles update-index --assume-unchanged "${bootstrap_file}" || true
  if [ -f "${bootstrap_file}" ]; then
    rm -f "${bootstrap_file}"
  fi
  dotfiles ls-files "${HOME}/install" 2>/dev/null | while IFS= read -r filename; do
    [ -z "${filename}" ] && continue
    echo "dotfiles, ignoring file: ${filename}"
    dotfiles update-index --assume-unchanged "${filename}" || true
    if [ -f "${HOME}/${filename}" ]; then
      echo "dotfiles, removing file: ${filename}"
      rm -f "${HOME}/${filename}"
    fi
  done || true
  if [ -d "${HOME}/install" ]; then
    echo "dotfiles, removing install directory if empty."
    rmdir "${HOME}/install" >/dev/null 2>&1 || true
  fi
  # let user settings be changed without tracking
  dotfiles update-index --skip-worktree "${ZDOTDIR:-$HOME/.config/zsh}/user-settings.zsh" || true
}

#########################################
# ARGUMENT PARSING

should_install_deno=false
should_install_fnm=false
should_install_pnpm=false
should_install_all=false

print_help_and_exit() {
  cat <<'EOF'
Usage: install.sh [options]

Optional components (installed by default if no component flags are provided):
  --with-deno        Install Deno
  --with-fnm         Install FNM (Fast Node Manager)
  --with-pnpm        Install pnpm

Aggregated flags:
  -a, --all          Install all optional components (same default behavior)

General:
  -h, --help         Show this help and exit

Behavior:
  If none of --with-* or --all is supplied, all optional components are installed
  to preserve the previous default behavior. Supplying any --with-* flag restricts
  installation to only the requested components (unless --all is also supplied).
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      print_help_and_exit ;;
    -a|--all)
      should_install_all=true ;;
    --with-deno)
      should_install_deno=true ;;
    --with-should_fnm)
      should_install_fnm=true ;;
    --with-pnpm)
      should_install_pnpm=true ;;
    -*)
      echo "Unknown option: $arg" >&2
      echo "Use --help to see available options." >&2
      exit 1 ;;
    *)
      echo "Ignoring unexpected positional argument: $arg" >&2 ;;
  esac
done


if [ "$should_install_all" = true ]; then
  should_install_deno=true
  should_install_fnm=true
  should_install_pnpm=true
fi

#########################################
# INSTALLATION FLOW

install_rustup
install_zoxide
install_starship
install_fisher
cargo install --locked zellij || true

if [ "$should_install_deno" = true ]; then
  install_deno
fi
if [ "$should_install_fnm" = true ]; then
  install_fnm
fi
if [ "$should_install_pnpm" = true ]; then
  install_pnpm
fi


# install git abbr plugin
fish -c "fisher install jhillyerd/plugin-git"  </dev/null


# install dotfiles
clean_prev_install_dotfiles
dotfiles_install
dotfiles_update_index


echo
echo
echo "change default shell to fish by running cmd below: (restart terminal afterwards)"
echo "chsh -s $(command -v fish)"  # NOTE: original script echoed fish
echo
