if status is-interactive
    # Commands to run in interactive sessions can go here
end


set -Ux EDITOR lvim
set -gx CONFIG_HOME "$HOME/.config"
set -gx CACHEDIR "$HOME/.cache"

# DOTFILELS
set -gx DOTFILES_DIR "$HOME/.dotfiles"
set -gx DOTFILES_REPO "https://raw.githubusercontent.com/ansemb/dotfiles/HEAD"

function dotfiles
  /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" $argv
end


# aliases
function ls
  exa -bh --color=auto $argv
end

function l
  ls -F $argv
end

function la
  ls -A $argv
end

function ll
  ls -lahg $argv
end

function lt
  ls --tree --long --level=2 $argv
end


# starship
starship init fish | source
