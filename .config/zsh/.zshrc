# zshrc

# functions
pathadd() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
       PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}


# import all paths
[ -f ~/.config/.paths ] && . ~/.config/.paths

# launch setup
[ -f "$ZDOTDIR/.setup" ] && source "$ZDOTDIR/.setup"


# solves tab space problem (when clicking tab, first characters repeat)
export LC_CTYPE=en_US.UTF-8

# colors
eval $( dircolors -b $HOME/.dir_colors)

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

# add settings if plugin-manager is installed
if [ -d "$ZPLUGIN_DIR" ] && [ -f "$ZDOTDIR/.plugin-manager-profile" ]; then
    . "$ZDOTDIR/.plugin-manager-profile"
else
    # use the default profile if no plugin manager is installed is not installed
    . "$ZDOTDIR/.zsh-default-profile"
fi


#
# Autoloads
#

autoload -Uz compinit promptinit

# shell is opened each day.
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files
promptinit

autoload -Uz allopt zed zmv zcalc colors
colors

autoload -Uz edit-command-line
zle -N edit-command-line

autoload -Uz select-word-style
select-word-style default

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

setopt complete_in_word
setopt always_to_end


# completion

zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

