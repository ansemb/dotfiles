#!/usr/bin/env bash
set -eu

detect_distro() {
  # prefer /etc/os-release
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    id=$(printf '%s' "$ID" | tr '[:upper:]' '[:lower:]')
    if [ "$id" = "ubuntu" ]; then
      echo ubuntu; return
    elif [ "$id" = "debian" ]; then
      echo debian; return
    fi

    # check ID_LIKE for debian-family
    if [ -n "${ID_LIKE-}" ]; then
      id_like=$(printf '%s' "$ID_LIKE" | tr '[:upper:]' '[:lower:]')
      case " $id_like " in
        *\ debian\ *) echo debian; return ;;
        *\ ubuntu\ *) echo ubuntu; return ;;
      esac
    fi
  fi

  # fallback: lsb_release if available
  if command -v lsb_release >/dev/null 2>&1; then
    dist=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    case "$dist" in
      ubuntu) echo ubuntu; return ;;
      debian) echo debian; return ;;
    esac
  fi

  # last-resort: presence of /etc/debian_version implies Debian-family
  if [ -r /etc/debian_version ]; then
    echo debian; return
  fi

  echo unknown
}

case "$(detect_distro)" in
  ubuntu)
    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y ppa:fish-shell/release-4
    sudo add-apt-repository -y ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install -y wget curl git make cmake fish helix gpg fd-find
    sudo apt install -y --no-install-recommends \
      build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev \
      libxmlsec1-dev libffi-dev liblzma-dev

    # eza
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
  ;;
  debian)
    sudo apt update
    sudo apt install -y gpg curl git
    sudo apt install --no-install-recommends \
    build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev -y

    # fish - debian 12
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:4.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null
    sudo apt update
    sudo apt install -y fish

    # helix
    wget https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb
    sudo apt update
    sudo apt install ./helix_25.7.1-1_amd64.deb
    rm ./helix_25.7.1-1_amd64.deb

    # eza
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
  ;;
  *) echo "Unknown / non-Debian family";;
esac

curl -sSfH https://raw.githubusercontent.com/ansemb/dotfiles/HEAD/install/install.sh | sh -s -- --all