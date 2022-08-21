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
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm

# dotnet
export DOTNET_ROOT="/opt/dotnet"
[ -d "$DOTNET_ROOT" ] && pathappend "$DOTNET_ROOT"

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
export CARGO_HOME="$HOME/.cargo"
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# gpg
export GPG_TTY=$(tty)

# den
export DENO_INSTALL="$HOME/.deno"
[ -d "$DENO_INSTALL/bin" ] && pathappend "$DENO_INSTALL/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[ -d "$PNPM_HOME" ] && pathappend "$PNPM_HOME"

# ruby version manager
[ -d "$HOME/.rvm/bin" ] && pathappend "$HOME/.rvm/bin"
[ -f "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
