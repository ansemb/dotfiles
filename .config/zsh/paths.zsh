#!/bin/zsh

# NVIM
export NVIMDIR="$CONFIG_HOME/nvim"
export NVIMUNDODIR="$NVIMDIR/undodir"

# PLUGIN MANAGER
export ZPLUGIN_DIR="$ZDOTDIR/zinit"
export ZINIT_HOME="$ZPLUGIN_DIR/zinit.git"

# Default programs:
export EDITOR='hx'

# Nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm

# dotnet
export DOTNET_ROOT="/opt/dotnet"
[ -d "$DOTNET_ROOT" ] && pathappend "$DOTNET_ROOT"

# brew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
[ -d "/home/linuxbrew/.linuxbrew/bin" ] && pathappend "/home/linuxbrew/.linuxbrew/bin"
[ -d "$HOME/.linuxbrew/bin" ] && pathappend "$HOME/.linuxbrew/bin"

test -d /opt/homebrew/bin && eval $(/opt/homebrew/bin/brew shellenv)
[ -d "/opt/homebrew/bin" ] && pathappend "/opt/homebrew/bin"

# local bin
pathappend "$HOME/.local/bin"

# pyenv init
export PYENV_ROOT="$CONFIG_HOME/.pyenv"
pathappend "$PYENV_ROOT/bin"
if type pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# zoxide
if type pyenv &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# yarn version manager
export YVM_DIR="$HOME/.yvm"
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# rustup
export RUSTUP_HOME="$HOME/.rustup"

# cargo
export CARGO_HOME="$HOME/.cargo"
pathappend "$CARGO_HOME"
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# gpg
export GPG_TTY=$(tty)

# den
export DENO_INSTALL="$HOME/.deno"
[ -d "$DENO_INSTALL/bin" ] && pathappend "$DENO_INSTALL/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[ -d "$PNPM_HOME" ] && pathappend "$PNPM_HOME"

# golang
[ -d "/usr/local/go/bin" ] && pathappend "/usr/local/go/bin"

# ruby version manager
[ -d "$HOME/.rvm/bin" ] && pathappend "$HOME/.rvm/bin"
[ -f "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"

