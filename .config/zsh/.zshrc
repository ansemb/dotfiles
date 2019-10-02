# zshrc

[ -f ~/.config/.paths ] && . ~/.config/.paths

# create cache dir if not exist
[ ! -d "$ZCACHEDIR" ] && mkdir -p "$ZCACHEDIR"

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


# create HISTFILE file if nonexisting
[ ! -f "$ZCACHEDIR/.history" ] && touch "$ZCACHEDIR/.history";

HISTSIZE=1000
SAVEHIST=2000
HISTFILE="$ZCACHEDIR/.history"


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


# ALIASES
[ -f "$HOME/.config/.aliases" ] && source "$HOME/.config/.aliases"
[ -f "$HOME/.config/.shortcutrc" ] && source "$HOME/.config/.shortcutrc"


# PLUGIN MANAGER
plugin_dir="$ZDOTDIR/.zplugin"

# install plugin manager if not installed
if [ ! -d "$plugin_dir" ]; then
    mkdir "$plugin_dir"
    git clone https://github.com/zdharma/zplugin.git "$plugin_dir/bin"
    zplugin self-update
fi

# add settings if plugin-manager is installed
if [ -d "$plugin_dir" ] && [ -f "$ZDOTDIR/.plugin-manager-profile" ]; then
    . "$ZDOTDIR/.plugin-manager-profile"
else
    # use the default profile if no plugin manager is installed is not installed
    . "$ZDOTDIR/.zsh-default-profile"
fi
unset -v plugin_dir



zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
