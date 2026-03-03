---
name: dotfiles
description: Read, query, and modify Adrian's dotfiles. Covers fish shell, zellij, tmux, helix, alacritty, aerospace, starship, and other configs managed in a bare git repo.
---

# /dotfiles - Dotfiles Management Skill

## Purpose

Provide context-aware assistance for reading, understanding, and modifying Adrian's personal dotfiles. The configs are managed as a bare git repo and cover the full terminal/desktop environment.

## When to Use

- User asks about their shell config, keybindings, aliases, or environment
- User wants to modify any dotfile (fish, zellij, tmux, helix, alacritty, aerospace, etc.)
- User asks "how do I do X" where X involves their terminal setup
- User asks about multiplexer keybindings or switching between tmux/zellij
- User wants to add/change aliases, abbreviations, or shell functions
- User asks about their window manager (aerospace) layout or bindings

## Bare Repo Setup

The dotfiles are tracked with a bare git repo:

- **Git dir:** `~/.dotfiles` (bare repo)
- **Work tree:** `$HOME`
- **Wrapper command:** `dotfiles` (fish function wrapping `/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME`)
- **Remote:** `https://github.com/ansemb/dotfiles` (user: ansemb)
- **Branch:** `master`

### Fish abbreviations for dotfiles

| Abbr    | Expands to           |
|---------|----------------------|
| `dfs`   | `dotfiles`           |
| `dfsa`  | `dotfiles add`       |
| `dfsst` | `dotfiles status`    |
| `dfsp`  | `dotfiles push`      |
| `dfscm` | `dotfiles commit -m` |

### Staging changes

To stage a modified dotfile, use the bare-repo wrapper:
```fish
dotfiles add <file-relative-to-HOME>
# e.g. dotfiles add .config/fish/config.fish
```

From Claude, the equivalent is:
```bash
/usr/bin/git --git-dir=/Users/adriannadausemb/.dotfiles --work-tree=/Users/adriannadausemb add <file>
```

## Tracked Config Files

### Core configs (read these first when relevant)

| Config       | Path                              | Format | Purpose                          |
|--------------|-----------------------------------|--------|----------------------------------|
| Fish shell   | `~/.config/fish/config.fish`      | fish   | Shell config, aliases, functions, PATH, env vars |
| Zellij       | `~/.config/zellij/config.kdl`     | KDL    | Terminal multiplexer (keybindings, themes, layout) |
| Tmux         | `~/.config/tmux/tmux.conf`        | tmux   | Terminal multiplexer (keybindings, theme, plugins) |
| Helix        | `~/.config/helix/config.toml`     | TOML   | Text editor (keybindings, theme, LSP) |
| Alacritty    | `~/.config/alacritty/alacritty.toml` | TOML | Terminal emulator (font, key passthrough, theme) |
| AeroSpace    | `~/.aerospace.toml`               | TOML   | Tiling window manager (workspaces, keybindings) |
| Starship     | `~/.config/starship.toml`         | TOML   | Shell prompt                     |
| Karabiner    | `~/.config/karabiner/karabiner.json` | JSON | Keyboard remapping              |

### Additional tracked files

- Fish plugins: `~/.config/fish/fish_plugins` (managed by fisher)
- Fish functions: `~/.config/fish/functions/`
- Fish themes: `~/.config/fish/themes/` (Catppuccin Mocha active)
- Helix languages: `~/.config/helix/languages.toml`
- Gitui: `~/.config/gitui/` (key bindings, themes)
- LunarVim: `~/.config/lvim/` (legacy)
- Zsh: `~/.config/zsh/` (legacy, still tracked)
- Bash: `~/.config/bash/` (legacy, still tracked)

## Key Conventions

### Theme
- **Catppuccin Mocha** everywhere: fish, zellij, tmux, helix, alacritty, gitui

### Multiplexer Prefix
- Both zellij and tmux use **Ctrl+Space** as prefix
- Alacritty sends `\u0000` (Ctrl+Space) on Cmd+Space
- Keybindings are deliberately kept parallel between zellij and tmux

### Multiplexer Switching (fish functions)
- `mux-attach-zellij` / `maz` — attach zellij (detach tmux if inside it)
- `mux-attach-tmux` / `mat` — attach tmux (detach zellij if inside it)
- `mux-toggle` / `mt` — toggle between the two
- `zellij-attach-last` / `zatt` — attach last zellij session
- `tmux-attach-last` / `tatt` — attach last tmux session

### Zellij Tab Naming
- Tabs are auto-named `N-` (index-prefix) on creation
- `zellij-new-tab [name]` / `znt` — new tab with auto-prefix
- `zellij-rename-tab [name]` / `zrt` — rename current tab with auto-prefix

### Common Keybinding Cheat Sheet (prefix = Ctrl+Space)

| Action              | Zellij             | Tmux               |
|---------------------|--------------------|---------------------|
| Split right         | prefix → v         | prefix → v          |
| Split down          | prefix → d         | prefix → d          |
| Navigate panes      | prefix → h/j/k/l   | prefix → h/j/k/l   |
| Resize panes        | prefix → H/J/K/L   | prefix → H/J/K/L   |
| New tab/window      | prefix → n         | prefix → n          |
| Go to tab N         | prefix → 1-9       | prefix → 1-9        |
| Toggle last tab     | prefix → Tab       | prefix → Tab         |
| Rename tab          | prefix → ,         | prefix → ,           |
| Search              | prefix → s         | prefix → s           |
| Scroll mode         | prefix → S         | prefix → S           |
| Fullscreen/zoom     | prefix → f         | prefix → f           |
| Close pane          | prefix → x         | prefix → x           |
| Detach              | prefix → Backspace | prefix → Backspace   |
| Pass-through prefix | prefix → a         | —                    |

### AeroSpace Window Manager
- **Focus:** Alt + h/j/k/l
- **Move window:** Alt+Shift + h/j/k/l
- **Workspaces:** Alt + 1-7, A-F, S, W, X, Z
- **Resize mode:** Alt+Space, then Shift+j/k
- **Service mode:** Alt+Shift+;
- App assignments: Alacritty→A, Browsers→W, Firefox→F, VS Code→E, Teams→2, Obsidian→3

### Editor
- **Helix** is the primary editor (`$EDITOR=hx`)
- Relative line numbers, Catppuccin Mocha theme, auto-pairs off
- Navigation: C-h/j/k/l for view switching, A-h/l for buffer cycling

### Shell Tools
- `eza` replaces `ls` (aliases: `ls`, `l`, `la`, `ll`, `lt`)
- `zoxide` for directory jumping (`z`)
- `starship` for prompt
- `fnm` for Node.js version management
- `pyenv` for Python
- `gitui` with Catppuccin Mocha theme

## Behavior

When the user invokes `/dotfiles` or asks about their dotfiles:

1. **Read the relevant config file(s)** before answering or making changes — configs evolve and the skill summary may be stale.
2. **Make targeted edits** — use the Edit tool, not full rewrites. Dotfiles are large and interconnected.
3. **Respect existing style** — match indentation, comment style, and organization of the file being edited.
4. **Stage changes** when asked, using the bare-repo wrapper:
   ```bash
   /usr/bin/git --git-dir=/Users/adriannadausemb/.dotfiles --work-tree=/Users/adriannadausemb add <file>
   ```
5. **Never commit or push** without explicit instruction. Only stage.
6. **Warn about side effects** — e.g., changing the prefix key affects both multiplexers and Alacritty's passthrough.
