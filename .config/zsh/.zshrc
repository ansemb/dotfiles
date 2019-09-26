

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




# PLUGIN MANAGER
PLUGIN_MANAGER=""
PLUGIN_MANAGER_DIR="$ZDOTDIR/.zplugin"

# add settings if plugin-manager is installed
if [ -d "$PLUGIN_MANAGER_DIR" ] && [ -f "$ZDOTDIR/.plugin-manager-profile" ]; then
    . "$ZDOTDIR/.plugin-manager-profile"
else
    # use the default profile if oh-my-zsh is not installed
    . "$ZDOTDIR/.zsh-default-profile"
fi

