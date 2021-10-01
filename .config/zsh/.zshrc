#!/bin/zsh

# zshrc

# functions
pathappend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
       PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

pathprepend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}


# import all paths
[ -f ~/.config/.paths ] && source ~/.config/.paths

# launch setup
[ -f "$ZDOTDIR/.setup" ] && source "$ZDOTDIR/.setup"


# solves tab space problem (when clicking tab, first characters repeat)
export LC_CTYPE=en_US.UTF-8

# colors
if whence dircolors >/dev/null; then
	eval "$(dircolors -b $HOME/.dir_colors)"
else
	export CLICOLOR=1
fi

# BINDKEYS
autoload up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e

# keybindings for zsh
bindkey "^[[1;5C"    forward-word # Ctrl+Right
bindkey "^[[1;5D"    backward-word # Ctrl+Left
bindkey "^[[5~"      up-history # PageUp
bindkey "^[[6~"      down-history # PageDown
bindkey "^W"      backward-kill-word
bindkey "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line
bindkey "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line
bindkey "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line
bindkey "\e[3~"   delete-char
bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char


# What characters are considered to be a part of a word
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

HISTSIZE=1000
SAVEHIST=2000
HISTFILE="$ZCACHEDIR/.history"


# ALIASES
[ -f "$HOME/.config/.aliases" ] && source "$HOME/.config/.aliases"
[ -f "$HOME/.config/.shortcutrc" ] && source "$HOME/.config/.shortcutrc"

# LOAD PLUGIN MANAGER
# install plugin manager if not installed
if [ ! -d "$ZPLUGIN_DIR" ]; then
    mkdir -p "$ZPLUGIN_DIR"
    git clone https://github.com/zdharma/zinit.git "$ZPLUGIN_DIR/bin"
fi

# check for update
[ -f "$ZDOTDIR/update" ] && source "$ZDOTDIR/update"


# add settings if plugin-manager is installed
if [ -d "$ZPLUGIN_DIR" ] && [ -f "$ZDOTDIR/.plugin-manager-profile" ]; then
    source "$ZDOTDIR/.plugin-manager-profile"
fi

# load autoloads and completions
[ -f "$ZDOTDIR/autoloads" ] && source "$ZDOTDIR/autoloads"

# load user settings
[ -f "$ZDOTDIR/user-settings.zsh" ] && source "$ZDOTDIR/user-settings.zsh"

