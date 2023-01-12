if status is-interactive
    # Commands to run in interactive sessions can go here
end


set -Ux EDITOR lvim
set -gx CONFIG_HOME "$HOME/.config"
set -gx CACHEDIR "$HOME/.cache"

fish_add_path "$HOME/.local/bin"

# DOTFILELS
set -gx DOTFILES_DIR "$HOME/.dotfiles"
set -gx DOTFILES_REPO "https://raw.githubusercontent.com/ansemb/dotfiles/HEAD"

# pyenv
set -gx PYENV_ROOT "$CONFIG_HOME/pyenv"
fish_add_path "$PYENV_ROOT/bin"
if type -q pyenv
  pyenv init - | source
end

# rustup
set -gx RUSTUP_HOME "$HOME/.config/rustup"

# cargo
set -gx CARGO_HOME "$CONFIG_HOME/cargo"
fish_add_path "$CARGO_HOME/bin"


# zoxide
if type -q zoxide
  zoxide init fish | source
end

# deno
set -gx DENO_INSTALL="$HOME/.deno"
fish_add_path "$DENO_INSTALL/bin"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"

# golang
fish_add_path "/usr/local/go/bin"

# gpg
set -gx GPG_TTY $(tty)

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
