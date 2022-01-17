#!/bin/zsh

# zshrc

# import common
[ -f "$ZDOTDIR/common.zsh" ] && source "$ZDOTDIR/common.zsh"

# import all paths
[ -f "$ZDOTDIR/paths.zsh" ] && source "$ZDOTDIR/paths.zsh"

# launch setup
[ -f "$ZDOTDIR/setup.zsh" ] && source "$ZDOTDIR/setup.zsh"

# import bindkeys
[ -f "$ZDOTDIR/bindkeys.zsh" ] && source "$ZDOTDIR/bindkeys.zsh"


# solves tab space problem (when clicking tab, first characters repeat)
export LC_CTYPE=en_US.UTF-8

# What characters are considered to be a part of a word
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# history
HISTSIZE=1000
SAVEHIST=2000
HISTFILE="$ZCACHEDIR/.history"


# import aliases
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# starship
(( $+commands[starship] )) && eval "$(starship init zsh)"

# LOAD PLUGIN MANAGER
# install plugin manager if not installed
if [ ! -d "$ZPLUGIN_DIR" ]; then
    mkdir -p "$ZPLUGIN_DIR"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# add settings if plugin-manager is installed
if [ -d "$ZPLUGIN_DIR" ] && [ -f "$ZDOTDIR/pluginrc.zsh" ]; then
    source "$ZDOTDIR/pluginrc.zsh"
fi

# load autoloads and completions
[ -f "$ZDOTDIR/autoloads.zsh" ] && source "$ZDOTDIR/autoloads.zsh"

# check for update
[ -f "$ZDOTDIR/update.zsh" ] && source "$ZDOTDIR/update.zsh"

# load user settings
[ -f "$ZDOTDIR/user-settings.zsh" ] && source "$ZDOTDIR/user-settings.zsh"

