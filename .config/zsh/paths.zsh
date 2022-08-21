#!/bin/zsh

# NVIM
export NVIMDIR="$CONFIG_HOME/nvim"
export NVIMUNDODIR="$NVIMDIR/undodir"

# PLUGIN MANAGER
export ZPLUGIN_DIR="$ZDOTDIR/zinit"
export ZINIT_HOME="$ZPLUGIN_DIR/zinit.git"

# Default programs:
export EDITOR='lvim'

# Nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# dotnet
export DOTNET_ROOT="/opt/dotnet"
pathappend "$DOTNET_ROOT"

# brew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
[ -d "/home/linuxbrew/.linuxbrew/bin" ] && pathappend "/home/linuxbrew/.linuxbrew/bin"
[ -d "$HOME/.linuxbrew/bin" ] && pathappend "$HOME/.linuxbrew/bin"

# local bin
pathappend "$HOME/.local/bin"

# pyenv init
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

# yarn version manager
export YVM_DIR="$HOME/.yvm"
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# cargo
[ -f "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# gpg
export GPG_TTY=$(tty)

# den
export DENO_INSTALL="$HOME/.deno"
pathappend "$DENO_INSTALL/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
pathappend "$PNPM_HOME"

# ruby version manager
pathappend "$HOME/.rvm/bin"
source "$HOME/.rvm/scripts/rvm"
