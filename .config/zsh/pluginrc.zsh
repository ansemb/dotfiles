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

# git extensions
zinit ice wait'2' lucid as"program" pick"$ZPFX/bin/git-now" make"prefix=$ZPFX install"
zinit light iwata/git-now

zinit lucid wait'0a' for \
as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" tj/git-extras

zinit ice wait'2' lucid as"program" atclone'perl Makefile.PL PREFIX=$ZPFX' atpull'%atclone' \
            make'install' pick"$ZPFX/bin/git-cal"
zinit light k4rthik/git-cal

# Plugin history-search-multi-word loaded with tracking.
zinit ice wait'2' lucid
zinit light zdharma-continuum/history-search-multi-word

# autocomplete
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

