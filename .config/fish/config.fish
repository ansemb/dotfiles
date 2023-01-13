if status is-interactive
    # Commands to run in interactive sessions can go here
end


set -Ux EDITOR lvim
set -gx CONFIG_HOME "$HOME/.config"
set -gx FISH_HOME "$CONFIG_HOME/fish"
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
set -gx DENO_INSTALL "$HOME/.deno"
fish_add_path "$DENO_INSTALL/bin"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"

# golang
fish_add_path "/usr/local/go/bin"

# gpg
# set -gx GPG_TTY $(tty)

# brew
if test -d ~/.linuxbrew
  # local installation
  eval ~/.linuxbrew/bin/brew shellenv
  fish_add_path "$HOME/.linuxbrew/bin"
end

if test -d /home/linuxbrew/.linuxbrew
  fish_add_path "/home/linuxbrew/.linuxbrew/bin"
  set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
  set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
  set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
  set -q PATH
  set -q MANPATH
  set -q INFOPATH
end


function dotfiles
  /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" $argv
end

function gitui
  "$CARGO_HOME/bin/gitui" -t themes/mocha.ron
end


# aliases
function ls --wraps "exa -bh --color=auto"
  exa -bh --color=auto $argv
end

function l --wraps "exa -bhF --color=auto"
  exa -bhF --color=auto $argv
end

function la --wraps "exa -bh --color=auto"
  exa -bh --color=auto $argv
end

function ll --wraps "exa -bh --color=auto"
  exa -bh --color=auto $argv
end

function lt --wraps "exa -bh --color=auto -tree --long --level=2"
  exa -bh --color=auto -tree --long --level=2 $argv
end


# theme
fish_config theme choose "Catppuccin Mocha"

# starship
starship init fish | source

nvm use 16
