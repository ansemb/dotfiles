#!/bin/zsh

# setup

# create history directory
[ ! -d "$ZCACHEDIR" ] && mkdir -p "$ZCACHEDIR"

[ ! -d "$ZDOTDIR/.tmp" ] && mkdir -p "$ZDOTDIR/.tmp"
