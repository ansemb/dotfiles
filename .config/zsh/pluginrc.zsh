#!/bin/zsh

# zinit profile

# if zinit is not installe when arriving here return
if [ ! -d "$ZPLUGIN_DIR" ]; then
    return
fi

# set custom directories
declare -A ZINIT # initial Zplugin's hash definition, if configuring before loading Zinit

ZINIT[BIN_DIR]="$ZINIT_HOME"
ZINIT[HOME_DIR]="$ZPLUGIN_DIR"
ZINIT[PLUGINS_DIR]="$ZPLUGIN_DIR/plugins"
source "$ZINIT[BIN_DIR]/zinit.zsh"

# set .z directory
export ZSHZ_DATA="$CACHEDIR/z"
export ZSH_HIGHLIGHT_MAXLENGTH=512
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)


# Load the prompt system and completion system and initilize them
#autoload -Uz _zinit
#(( ${+_comps} )) && _comps[zinit]=_zinit



# PLUGINS

# load oh-my-zsh setup
setopt promptsubst
zinit wait lucid for \
    OMZL::git.zsh \
  atload"unalias grv; zinit cdclear -q" \
    OMZP::git \
    OMZP::history


# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zinit ice atclone"dircolors -b "$home/.dir_colors"  > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

zinit ice wait'2' lucid as"program" pick"bin/git-dsf"
zinit light zdharma-continuum/zsh-diff-so-fancy

zinit lucid wait'0a' for \
as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" tj/git-extras

# autocomplete
zinit wait lucid light-mode for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

