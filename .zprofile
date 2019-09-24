# Profile file. Runs on login. Environmental variables are set here.

# Default programs:
export EDITOR='nvim'

# ~/ paths
export ZDOTDIR="$HOME/.config/zsh"
export ZCACHEDIR="$HOME/.cache/zsh"

# create cache dir if not exist
[ ! -d "$ZCACHEDIR" ] && mkdir -p "$ZCACHEDIR"

