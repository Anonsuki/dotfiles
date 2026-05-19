# --- 1. Path & Environment ---
# Prioritize Rust binaries in .cargo/bin
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export COLORTERM=truecolor

# --- 2. Initialize the Engine (Sheldon) ---
# This loads Starship, Autosuggestions, and plugins defined in plugins.toml
autoload -Uz compinit
# Check if .zcompdump exists and was modified today (using GNU date)
if [ "$(date +'%j')" != "$(date -r ~/.zcompdump +%j 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi
eval "$(sheldon source)"

# --- 3. The "Modern Unix" Aliases (Rust Stack) ---
# Navigation
alias ..="z .."
alias ...="z ../.."
alias ~="z ~"
alias -- -="z -"

# File Listing (eza)
alias ls="eza --icons=always --git --group-directories-first"
alias ll="eza -l --icons=always --git --group-directories-first"
alias la="eza -la --icons=always --git --group-directories-first"
alias lt="eza --tree --level=2 --icons=always --group-directories-first"

# Reading & Searching
alias cat="bat" # Syntax highlighted reading
alias grep="rg" # Ripgrep
alias find="fd" # Fd

# Personal Aliases
alias p="pwd"
alias v="nvim"
alias e="export DISPLAY=:0
emacs &"
alias lg="lazygit"
alias zshconfig="nvim ~/.zshrc"
alias sheldonconfig="nvim ~/.config/sheldon/plugins.toml"
alias youtube="bash ~/yt-download.sh"
alias ff="fastfetch"

# --- 4. Git CLI Shortcuts (Use alongside Lazygit)---
alias gs="git status -sb" # Short-format status with branch tracking
alias ga="git add"
alias gA="git add -A"     # Stages everything, including deletions
alias gc="git commit -v"  # Verbose: shows the diff of what you are committing in your editor
alias gc!="git commit -v --amend --no-edit" # Instantly overwrite the last commit without changing the message
alias gl="git pull --prune" # Pulls and cleans up deleted remote tracking branches
alias gp="git push"
alias gp!="git push --force-with-lease" # vastly safer than --force; prevents overwriting teammates' work
alias gb="git branch"
alias gco="git checkout"

# --- 5. Tool Integrations ---

# Initialize Atuin (Magic History)
eval "$(atuin init zsh)"

# Initialize Zoxide (Smart CD)
eval "$(zoxide init zsh)"

# Configure FZF (Fuzzy Finder)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- 6. Custom Functions ---

# Yazi Wrapper (allows changing directory on exit)
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Enable Vim keybindings in terminal
bindkey -v
export KEYTIMEOUT=1

export BAT_THEME="gruvbox-dark"

export PATH="$HOME/.emacs.d/bin:$PATH"

export PATH="$HOME/.config/emacs/bin:$PATH"

# --- 7. Advanced Zsh Behaviors (The Extractions) ---

# Quality of Life Options
setopt AUTO_CD              # Type a directory name to instantly cd into it
setopt INTERACTIVE_COMMENTS # Allow # comments in the interactive prompt

# The Neovim Bridge: Edit long terminal commands in Neovim
autoload -Uz edit-command-line
zle -N edit-command-line
# Maps the 'v' key in normal mode to open Neovim
bindkey -M vicmd 'v' edit-command-line

# --- 8. The Completion Engine Overhaul ---
# Forces an interactive, navigable menu for tab completion
zstyle ':completion:*' menu select

# Enables smart case-insensitivity and partial word fuzzy matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Caches completion calculations to heavily reduce CPU load on complex commands (like git or npm)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# Colorizes the completion menu to match your standard terminal colors (eza/ls)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
