if status is-interactive
    # Commands to run in interactive sessions can go here
end

# install fisher (https://github.com/jorgebucaran/fisher)
# curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# 
# install bash (https://github.com/edc/bass)
# fisher install edc/bass
# 

set -Ux EDITOR hx
set -gx CONFIG_HOME "$HOME/.config"
set -gx FISH_HOME "$CONFIG_HOME/fish"
set -gx CACHEDIR "$HOME/.cache"

fish_add_path "$HOME/.local/bin"
fish_add_path /usr/local/bin

# fnm (node version manager)
# fnm - https://github.com/Schniz/fnm
# "curl -fsSL https://fnm.vercel.app/install | bash"
# set FNM_PATH "$HOME/Library/Application Support/fnm"

if test (uname) = Linux
    set FNM_PATH "/home/vscode/.local/share/fnm"
else
    set FNM_PATH /opt/homebrew/bin/fnm
end
fish_add_path "$FNM_PATH"

# DOTFILELS
set -gx DOTFILES_DIR "$HOME/.dotfiles"
set -gx DOTFILES_REPO "https://raw.githubusercontent.com/ansemb/dotfiles/HEAD"

# pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
fish_add_path "$PYENV_ROOT/bin"
if type -q pyenv
    pyenv init - | source
end

# rustup
set -gx RUSTUP_HOME "$HOME/.rustup"

# cargo
set -gx CARGO_HOME "$HOME/.cargo"
fish_add_path "$CARGO_HOME/bin"

# llvm
if test -d /opt/homebrew/opt/llvm/bin
    fish_add_path /opt/homebrew/opt/llvm/bin
    set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
    set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include
end

# deno
set -gx DENO_INSTALL "$HOME/.deno"
fish_add_path "$DENO_INSTALL/bin"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"

# golang
fish_add_path /usr/local/go/bin

# gpg
# set -gx GPG_TTY $(tty)

# brew
if test -d ~/.linuxbrew
    # local installation
    eval ~/.linuxbrew/bin/brew shellenv
    fish_add_path "$HOME/.linuxbrew/bin"
    fish_add_path "$HOME/.linuxbrew/sbin"
end

if test -d /home/linuxbrew/.linuxbrew
    fish_add_path "/home/linuxbrew/.linuxbrew/bin"
    fish_add_path "/home/linuxbrew/.linuxbrew/sbin"
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
    set -q PATH
    set -q MANPATH
    set -q INFOPATH
end

if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
    set -gx HOMEBREW_PREFIX /opt/homebrew/bin
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    set -q PATH
    set -gx MANPATH /opt/homebrew/share/man $MANPATH
    set -q MANPATH
    set -q INFOPATH
end

if test -d /opt/homebrew/opt/node@18/bin
    fish_add_path "/opt/homebrew/opt/node@18/bin"
end

if test -d /opt/homebrew/opt/node@20/bin
    fish_add_path "/opt/homebrew/opt/node@20/bin"
end

if test -d /opt/homebrew/opt/node@22/bin
    fish_add_path "/opt/homebrew/opt/node@22/bin"
end

if test -d /usr/local/share/dotnet
    set -Ux DOTNET_ROOT /usr/local/share/dotnet
    fish_add_path /usr/local/share/dotnet
end

if test -d "$HOME/.dotnet"
    set -Ux DOTNET_ROOT $HOME/.dotnet
    fish_add_path "$HOME/.dotnet"
end

function dotfiles
    /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" $argv
end

function gitui
    "$CARGO_HOME/bin/gitui" -t themes/mocha.ron
end

function zel-last
    zellij attach (zellij list-sessions | head -1)
end

# aliases
function ls --wraps "eza -bh --color=auto"
    eza -bh --color=auto $argv
end

function l --wraps "eza -bhF --color=auto"
    eza -bhF --color=auto $argv
end

function la --wraps "eza -bhA --color=auto"
    eza -bhA --color=auto $argv
end

function ll --wraps "eza -bhlag --color=auto"
    eza -bhlag --color=auto $argv
end

function lt --wraps "eza -bh --color=auto -tree --long --level=2"
    eza -bh --color=auto --tree --long --level=2 $argv
end

function dotfiles-default-config
    dotfiles config user.name ansemb
    dotfiles config user.email 31008843+ansemb@users.noreply.github.com
    dotfiles config branch.master.remote origin
    dotfiles config branch.master.merge refs/heads/master
end

alias sudo="sudo -s"

alias git-autoremote="git config --global push.autoSetupRemote true"

alias git-user-config="git config user.name ansemb; git config user.email '31008843+ansemb@users.noreply.github.com'"
alias git-user-config-global="git config --global user.name ansemb; git config --global user.email '31008843+ansemb@users.noreply.github.com'"
# git config --global --get user.email
# git config --global --get user.name

abbr -a -- dfs dotfiles
abbr -a -- dfsa 'dotfiles add'
abbr -a -- dfsst 'dotfiles status'
abbr -a -- dfsp 'dotfiles push'
abbr -a -- dfscm 'dotfiles commit -m'

abbr -a -- fp 'path resolve'

# attach the last zellij session
function zlast
    # -n strips formatting/colors
    # tail -n1 gets the last line
    # string split gets the session name (first column)
    set session (zellij list-sessions -n | tail -n1 | string split " " -f1)

    if test -n "$session"
        zellij attach "$session"
    else
        echo "No zellij sessions found."
    end
end

# function hx --wraps "hx"
#   "hx" $argv
# end

# theme
fish_config theme choose "Catppuccin Mocha"

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# starship
if type -q starship
    starship init fish | source
end

# osxcross
set -gx OSX_SDK_VERSION 13.1
set -gx OSX_VERSION_MIN 10.14
set -gx MACOSX_DEPLOYMENT_TARGET "$OSX_VERSION_MIN"
fish_add_path /usr/local/osxcross/target/bin

set -gx NODE_OPTIONS "--max-old-space-size=32768"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f "$HOME/miniconda3/bin/conda"
    eval "$HOME/miniconda3/bin/conda" "shell.fish" hook $argv | source
else
    if test -f "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

switch (uname)
    case Linux
        fish_add_path -g ~/.local/linux/bin
end
