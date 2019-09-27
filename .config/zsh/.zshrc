# zshrc

# create cache dir if not exist
[ ! -d "$ZCACHEDIR" ] && mkdir -p "$ZCACHEDIR"

[ -f "$ZDOTDIR/.functions" ] && . 

# BINDKEYS
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


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
