
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
bindkey "^u"      backward-kill-line
bindkey "^w"      backward-kill-word
bindkey "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line
bindkey "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line
bindkey "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line
bindkey "\e[3~"   delete-char
bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char

