# Profile file. Runs on login. Environmental variables are set here.

# Default programs:
export EDITOR='nvim'

# ~/ paths
export ZDOTDIR="$HOME/.config/zsh"
export ZCACHEDIR="$HOME/.cache/zsh"

# z plugin path
export _Z_DATA="$ZCACHEDIR/.z"


# create cache dir if not exist
[ ! -d "$ZCACHEDIR" ] && mkdir -p "$ZCACHEDIR"

