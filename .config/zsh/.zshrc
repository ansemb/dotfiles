

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
plugin_dir="$ZDOTDIR/.zplugin"

# install plugin manager if not installed
if [ ! -d "$plugin_dir" ]; then
    mkdir "$plugin_dir"
    git clone https://github.com/zdharma/zplugin.git "$plugin_dir/bin"
fi

# add settings if plugin-manager is installed
if [ -d "$plugin_dir" ] && [ -f "$ZDOTDIR/.plugin-manager-profile" ]; then
    . "$ZDOTDIR/.plugin-manager-profile"
else
    # use the default profile if no plugin manager is installed is not installed
    . "$ZDOTDIR/.zsh-default-profile"
fi

