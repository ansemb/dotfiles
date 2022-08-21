#!/bin/zsh

# for git dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# for git system settings
alias config='/usr/bin/git --git-dir=$HOME/.config/system/ --work-tree=/'

# vim
alias vim='lvim'

# run these aliases as sudo
alias sudo='sudo '

# list aliases
alias ls="exa -bh --color=auto"
alias ll='ls -lahg' l.='ls -d .*'
alias la='ls -A'
alias l='ls -F' 


alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto"

