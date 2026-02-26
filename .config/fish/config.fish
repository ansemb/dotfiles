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

# nuget auth - trigger CanShowDialog instead of Device Flow
# - https://github.com/microsoft/artifacts-credprovider
set -gx ARTIFACTS_CREDENTIALPROVIDER_FORCE_CANSHOWDIALOG_TO true

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

#### AGENCY
if test -d "$HOME/.claude-cli/currentVersion"
    fish_add_path "$HOME/.claude-cli/currentVersion"
end

if test -d "$HOME/.config/agency/CurrentVersion"
    fish_add_path "$HOME/.config/agency/CurrentVersion"
end

####

function dotfiles
    /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" $argv
end

function gitui
    "$CARGO_HOME/bin/gitui" -t themes/mocha.ron
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

# ---------------------------------------------------------------------------
# Multiplexer functions
# ---------------------------------------------------------------------------
# Default session name for both tmux and zellij
set -g MUX_MAIN_SESSION "main"

# --- Internal helpers ---

set -g __MUX_STATE_DIR "$HOME/.cache/mux"

function __zellij_save_tab --description "Save the focused zellij tab index for later restore"
    set -l session_name "$ZELLIJ_SESSION_NAME"
    if test -z "$session_name"
        return
    end
    mkdir -p "$__MUX_STATE_DIR"
    set -l tab_idx (zellij action dump-layout 2>/dev/null | grep "^    tab " | grep -n "focus=true" | cut -d: -f1)
    if test -n "$tab_idx"
        echo "$tab_idx" > "$__MUX_STATE_DIR/zellij-tab-$session_name"
    end
end

function __zellij_restore_tab --description "Restore the last focused tab after zellij attach"
    # Called in background after attach. Waits for zellij to be ready,
    # then switches to the saved tab.
    set -l session_name "$argv[1]"
    set -l state_file "$__MUX_STATE_DIR/zellij-tab-$session_name"
    if not test -f "$state_file"
        return
    end
    set -l tab_idx (cat "$state_file")
    rm -f "$state_file"
    if test -n "$tab_idx" -a "$tab_idx" -gt 1 2>/dev/null
        sleep 0.3
        zellij action go-to-tab "$tab_idx" 2>/dev/null
    end
end

function __zellij_detach --description "Programmatically detach from zellij"
    if not set -q ZELLIJ
        echo "Not inside a zellij session."
        return 1
    end
    # Save current tab before detaching
    __zellij_save_tab
    # zellij 0.43 has no CLI detach action. We switch to tmux mode then
    # simulate a Backspace keystroke to trigger the Detach keybinding.
    zellij action switch-mode tmux
    sleep 0.05
    if test (uname) = Darwin
        osascript -e 'tell application "System Events" to key code 51' &
        disown
    else
        # On Linux, try xdotool (X11) or ydotool (Wayland)
        if type -q xdotool
            xdotool key BackSpace &
            disown
        else if type -q ydotool
            ydotool key 14 &
            disown
        else
            echo "Cannot simulate detach. Press Ctrl-Space → Backspace manually."
            return 1
        end
    end
end

function __mux_check_switch_target --description "Check for pending mux switch after zellij detach"
    if test -f /tmp/.mux-switch-target
        set -l target (cat /tmp/.mux-switch-target)
        rm -f /tmp/.mux-switch-target
        if test "$target" = "tmux"
            mux-attach-tmux
        else if test "$target" = "zellij"
            mux-attach-zellij
        end
    end
end

function __zellij_attach_main --description "Attach or create the main zellij session"
    if zellij list-sessions -rs 2>/dev/null | grep -q "^$MUX_MAIN_SESSION\$"
        echo "Attaching zellij session: $MUX_MAIN_SESSION"
        # Restore last focused tab in background after attach settles
        fish -c "__zellij_restore_tab $MUX_MAIN_SESSION" &
        disown
        zellij attach "$MUX_MAIN_SESSION"
    else
        echo "Creating new zellij session: $MUX_MAIN_SESSION"
        zellij -s "$MUX_MAIN_SESSION"
    end
    __mux_check_switch_target
end

function __tmux_attach_main --description "Attach or create the main tmux session"
    if tmux has-session -t "$MUX_MAIN_SESSION" 2>/dev/null
        echo "Attaching tmux session: $MUX_MAIN_SESSION"
        tmux attach -t "$MUX_MAIN_SESSION"
    else
        echo "Creating new tmux session: $MUX_MAIN_SESSION"
        tmux new-session -s "$MUX_MAIN_SESSION"
    end
end

# --- Legacy attach functions ---

function zellij-attach-last
    set session (zellij list-sessions -rs | head -1)
    if test -n "$session"
        echo "zellij attach $session"
        fish -c "__zellij_restore_tab $session" &
        disown
        zellij attach "$session"
    else
        echo "No zellij sessions found."
        zellij list-sessions
    end
    __mux_check_switch_target
end

function tmux-attach-last
    set session (tmux list-sessions -F '#{session_name}' 2>/dev/null | head -1)
    if test -n "$session"
        echo "tmux attach -t $session"
        tmux attach -t "$session"
    else
        echo "No tmux sessions found. Starting new session."
        tmux new-session
    end
end

# --- Main multiplexer switching functions ---

function mux-attach-zellij --description "Attach to main zellij session (detach from tmux if needed)"
    if set -q ZELLIJ
        echo "Already inside a zellij session."
        return 0
    else if set -q TMUX
        echo "Leaving tmux → attaching zellij ($MUX_MAIN_SESSION)..."
        tmux detach-client -E "fish -c mux-attach-zellij"
    else
        __zellij_attach_main
    end
end

function mux-attach-tmux --description "Attach to main tmux session (detach from zellij if needed)"
    if set -q TMUX
        echo "Already inside a tmux session."
        return 0
    else if set -q ZELLIJ
        echo "Leaving zellij → attaching tmux ($MUX_MAIN_SESSION)..."
        echo "tmux" > /tmp/.mux-switch-target
        __zellij_detach
    else
        __tmux_attach_main
    end
end

function mux-toggle --description "Toggle between zellij and tmux (default to zellij if outside both)"
    if set -q ZELLIJ
        echo "In zellij → switching to tmux ($MUX_MAIN_SESSION)..."
        echo "tmux" > /tmp/.mux-switch-target
        __zellij_detach
    else if set -q TMUX
        echo "In tmux → switching to zellij ($MUX_MAIN_SESSION)..."
        tmux detach-client -E "fish -c mux-attach-zellij"
    else
        echo "Not inside any multiplexer. Defaulting to zellij."
        mux-attach-zellij
    end
end

function zellij-rename-to-main --description "Rename current zellij session to main (if main doesn't exist)"
    if not set -q ZELLIJ
        echo "Not inside a zellij session."
        return 1
    end
    if zellij list-sessions -rs 2>/dev/null | grep -q "^$MUX_MAIN_SESSION\$"
        echo "A session named '$MUX_MAIN_SESSION' already exists."
        return 1
    end
    zellij action rename-session "$MUX_MAIN_SESSION"
    echo "Renamed current session to '$MUX_MAIN_SESSION'."
end

# --- Zellij tab naming helpers ---
# __zellij_auto_name_tab is also called from the zellij keybinding (Ctrl-Space → n)
# via WriteChars, so new tabs are automatically named "N-".
# Zellij keybindings can't inject dynamic values, so these are shell functions
# instead of keybindings. Use from the command line:
#   znt              → create tab named "9-"
#   znt docs         → create tab named "9-docs"
#   zrt relay-issue  → rename current tab to "3-relay-issue"
#   zrt              → rename current tab to "3-"
# Abbreviations: znt = zellij-new-tab, zrt = zellij-rename-tab

function __zellij_focused_tab_index --description "Get the 1-based index of the currently focused zellij tab"
    zellij action dump-layout 2>/dev/null | grep "^    tab " | grep -n "focus=true" | cut -d: -f1
end

function __zellij_auto_name_tab --description "Rename current zellij tab to N- (used by keybinding and zellij-new-tab)"
    set -l idx (__zellij_focused_tab_index)
    if test -n "$idx"
        zellij action rename-tab "$idx-"
    end
end

function zellij-rename-tab --description "Rename current zellij tab to N-NAME (auto-prefixes tab index)"
    if not set -q ZELLIJ
        echo "Not inside a zellij session."
        return 1
    end
    set -l idx (__zellij_focused_tab_index)
    if test -z "$idx"
        echo "Could not determine current tab index."
        return 1
    end
    if test (count $argv) -eq 0
        zellij action rename-tab "$idx-"
    else
        zellij action rename-tab "$idx-$argv"
    end
end

function zellij-new-tab --description "Create a new zellij tab, auto-named N- or N-NAME"
    if not set -q ZELLIJ
        echo "Not inside a zellij session."
        return 1
    end
    zellij action new-tab
    sleep 0.1
    set -l idx (__zellij_focused_tab_index)
    if test -z "$idx"
        return
    end
    if test (count $argv) -eq 0
        zellij action rename-tab "$idx-"
    else
        zellij action rename-tab "$idx-$argv"
    end
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

abbr -a zatt zellij-attach-last
abbr -a tatt tmux-attach-last
abbr -a maz mux-attach-zellij
abbr -a mat mux-attach-tmux
abbr -a mt mux-toggle
abbr -a zrm zellij-rename-to-main
abbr -a zrt zellij-rename-tab
abbr -a znt zellij-new-tab

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

if type -q fnm
    fnm env --use-on-cd --shell fish | source
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
# 
set -gx MIDGARD_BACKFILL_CACHE_DIR "$HOME/.cache/midgard-build-cache"

switch (uname)
    case Linux
        fish_add_path -g ~/.local/linux/bin
end

# pnpm
set -gx PNPM_HOME "/Users/adriannadausemb/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
