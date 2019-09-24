
# add oh-my-zsh settings if installed
[ ! -d "$ZDOTDIR/.oh-my-zsh-profile" ] && . "$ZDOTDIR/.oh-my-zsh-profile"
# use the default profile if oh-my-zsh is not installed
if [ ! -d "$ZSH" ]; then
    . "$ZDOTDIR/.zsh-default-profile"
fi

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# create HISTFILE file if nonexisting
[ ! -f "$ZCACHEDIR/.history" ] && touch "$ZCACHEDIR/.history";

HISTSIZE=1000
SAVEHIST=2000
HISTFILE="$ZCACHEDIR/.history"

# load aliases and shortcuts if exist
[ -f "$HOME/.config/.aliases" ] && source "$HOME/.config/.aliases"
[ -f "$HOME/.config/.shortcutrc" ] && source "$HOME/.config/.shortcutrc"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
