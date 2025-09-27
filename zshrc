# ~/.zshrc - Fedora-Optimized Power User Configuration
# Designed for battery efficiency and maximum productivity

# ===== PERFORMANCE OPTIMIZATIONS =====

# Skip global compinit for faster startup (saves ~50-100ms on shell startup)
# Fedora's zsh package runs compinit globally, this prevents duplicate execution
skip_global_compinit=1

# History configuration - optimized for power users
HISTSIZE=10000          # Keep 10k commands in memory (balance between utility and RAM usage)
SAVEHIST=5000           # Save 5k to disk (reduces I/O operations, better for SSDs)
HISTFILE=~/.zsh_history # Standard location, works with Fedora's default setup

# Essential history options (each saves CPU cycles and improves UX)
setopt HIST_IGNORE_DUPS      # Don't record duplicate consecutive commands (reduces history bloat)
setopt HIST_IGNORE_SPACE     # Commands starting with space aren't recorded (useful for sensitive commands)
setopt HIST_EXPIRE_DUPS_FIRST # When trimming history, remove duplicates first (keeps unique commands longer)
setopt HIST_SAVE_NO_DUPS     # Don't save duplicate commands to history file (reduces disk I/O)
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching history (cleaner search results)
setopt HIST_REDUCE_BLANKS    # Remove extra blanks from commands before recording (cleaner history)

# ===== CORE ZSH OPTIONS (Fedora-specific optimizations) =====

setopt AUTO_CD               # Type directory name to cd into it (faster navigation)
setopt INTERACTIVE_COMMENTS  # Allow # comments in interactive shell (useful for documenting commands)
setopt NO_NOMATCH           # Don't error on unmatched globs, pass them through (prevents zsh errors)
setopt NOTIFY               # Report background job status immediately (important for development)
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically (file1, file2, file10 vs file1, file10, file2)
setopt PROMPT_SUBST         # Enable parameter expansion in prompts (allows dynamic prompts)
setopt GLOB_DOTS            # Include dotfiles in glob patterns (matches Fedora user expectations)
setopt AUTO_PUSHD           # Automatically push directories to stack on cd (enables directory history)
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories (keeps stack clean)
setopt PUSHD_SILENT         # Don't print directory stack after pushd (less noise)
setopt CORRECT              # Suggest corrections for mistyped commands (helps with typos)
setopt COMPLETE_IN_WORD     # Complete from cursor position, not just end (better completion UX)
setopt ALWAYS_TO_END        # Move cursor to end after completion (consistent behavior)
setopt HASH_LIST_ALL        # Hash entire command path on first execution (faster subsequent runs)

# Word separators optimized for path navigation and development
# Removes / and . from word characters so Ctrl+W stops at path components
WORDCHARS=${WORDCHARS//\/[&.;]}

# ===== FEDORA-OPTIMIZED PROMPT =====
# Lightweight prompt that shows essential info without battery drain
autoload -U colors && colors  # Load color support (standard zsh feature)

setup_prompt() {
    # Color scheme optimized for Fedora's default terminal themes
    local user_color="%F{blue}"     # Blue for regular users (Fedora's brand color)
    local path_color="%F{green}"    # Green for paths (good contrast, easy to read)
    local host_color="%F{cyan}"     # Cyan for hostname (distinguishes from path)
    local reset="%f"                # Reset colors

    # Security: Root gets red prompt (visual warning for privileged operations)
    [[ $EUID -eq 0 ]] && user_color="%F{red}"

    # Efficient single-line prompt (reduces terminal scrolling, better for laptops)
    # %n = username, %m = hostname, %~ = current directory with ~ substitution
    PROMPT="${user_color}%n${reset}@${host_color}%m${reset}:${path_color}%~${reset}%# "

    # Minimal right prompt showing only exit status of last command
    # %? = exit status, only shown if non-zero (reduces visual clutter)
    RPROMPT='%(?..%F{red}✘[%?]%f)'
}

setup_prompt

# ===== OPTIMIZED KEYBINDINGS =====
# Emacs-style bindings (more efficient than vi mode for most users)
bindkey -e

# Essential navigation keybindings (works with Fedora's default terminal)
bindkey '^[[H'    beginning-of-line     # Home key
bindkey '^[[F'    end-of-line          # End key
bindkey '^[[3~'   delete-char          # Delete key
bindkey '^[[5~'   up-line-or-history   # Page Up (scroll through history)
bindkey '^[[6~'   down-line-or-history # Page Down
bindkey '^R'      history-incremental-search-backward  # Ctrl+R (essential for power users)
bindkey '^S'      history-incremental-search-forward   # Ctrl+S

# Word-based navigation (essential for editing long commands)
bindkey '^[b'     backward-word        # Alt+B (move back one word)
bindkey '^[f'     forward-word         # Alt+F (move forward one word)
bindkey '^W'      backward-kill-word   # Ctrl+W (delete word backward)
bindkey '^[d'     kill-word            # Alt+D (delete word forward)

# ===== COMPLETION SYSTEM (Fedora-optimized) =====
# Intelligent completion loading for faster startup
autoload -Uz compinit

# Performance optimization: only rebuild completion cache once per day
# This significantly speeds up shell startup on Fedora systems
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.cache/zcompdump      # Full rebuild if cache is old
else
    compinit -C -d ~/.cache/zcompdump   # Fast loading if cache is fresh
fi

# Completion styles optimized for Fedora package management and development
zstyle ':completion:*' menu select              # Visual menu for completions
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Use system colors from dircolors
zstyle ':completion:*' rehash true              # Always check for new programs (important with dnf installs)
zstyle ':completion:*' use-cache true           # Cache completions for speed
zstyle ':completion:*' cache-path ~/.cache/zsh  # Use XDG-compliant cache location

# Fedora-specific completion optimizations
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:dnf:*' tag-order packages  # Prioritize packages for dnf completion

# ===== FEDORA-SPECIFIC ALIASES =====

# System management (Fedora's package manager and systemd)
alias dnfi='sudo dnf install'           # Quick package install
alias dnfs='dnf search'                 # Search packages
alias dnfu='sudo dnf update'            # Update system packages
alias dnfr='sudo dnf remove'            # Remove packages
alias dnfh='dnf history'                # Package history (useful for troubleshooting)
alias dnfc='sudo dnf clean all'         # Clean package cache (frees disk space)
alias dnfg='dnf group'                  # Package groups
alias dnfl='dnf list'                   # List packages

# Flatpak integration (Fedora's preferred sandboxed app format)
alias flati='flatpak install'           # Install flatpak
alias flatu='flatpak update'            # Update flatpaks
alias flatr='flatpak remove'            # Remove flatpak
alias flats='flatpak search'            # Search flatpaks
alias flatl='flatpak list'              # List installed flatpaks

# Systemd service management (essential for Fedora servers/desktops)
alias sc='sudo systemctl'               # Quick systemctl access
alias scu='systemctl --user'            # User systemctl
alias jc='journalctl'                   # View logs
alias jcf='journalctl -f'               # Follow logs (like tail -f)
alias jcu='journalctl --user'           # User logs

# Essential system monitoring
alias c='clear'                         # Quick clear
alias cl='clear && ls'                  # Clear and list (common workflow)
alias q='exit'                          # Quick exit
alias h='history | tail -20'            # Show recent history

# Enhanced ls with fallback (eza is better but not always available)
if command -v eza > /dev/null 2>&1; then
    alias ls='eza --icons=auto --group-directories-first'  # Modern ls replacement
    alias ll='eza -la --icons=auto --group-directories-first --header'  # Detailed list
    alias lt='eza --tree --level=3 --icons=auto'           # Tree view (limited depth for performance)
    alias ld='eza -lD --icons=auto'                        # Directories only
    alias lf='eza -lf --icons=auto'                        # Files only
else
    # Fallback to GNU coreutils (always available on Fedora)
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -la --color=auto --group-directories-first'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# Directory navigation (essential for productivity)
alias ..='cd ..'                        # Up one directory
alias ...='cd ../..'                    # Up two directories
alias ....='cd ../../..'                # Up three directories
alias .....='cd ../../../..'            # Up four directories
alias -- -='cd -'                       # Go to previous directory

# Git workflow (essential for developers)
alias g='git'                           # Quick git access
alias ga='git add'                      # Stage files
alias gaa='git add --all'               # Stage all changes
alias gc='git commit -m'                # Commit with message
alias gca='git commit --amend'          # Amend last commit
alias gco='git checkout'                # Switch branches
alias gcb='git checkout -b'             # Create and switch to new branch
alias gd='git diff'                     # Show differences
alias gdc='git diff --cached'           # Show staged differences
alias gl='git log --oneline --graph --decorate --all' # Pretty log
alias gp='git push'                     # Push changes
alias gpu='git pull'                    # Pull changes
alias gs='git status -sb'               # Short status
alias gst='git stash'                   # Stash changes
alias gstp='git stash pop'              # Apply stash

# File operations with safety features
alias cp='cp -iv'                       # Interactive, verbose copy
alias mv='mv -iv'                       # Interactive, verbose move
alias rm='rm -iv'                       # Interactive, verbose remove (prevents accidents)
alias mkdir='mkdir -pv'                 # Create parent directories, verbose
alias chmod='chmod --preserve-root'     # Prevent chmod on root directory
alias chown='chown --preserve-root'     # Prevent chown on root directory

# System information (useful for troubleshooting)
alias df='df -h'                        # Human-readable disk usage
alias du='du -h'                        # Human-readable directory sizes
alias free='free -h'                    # Human-readable memory usage
alias ps='ps aux'                       # Show all processes
alias psg='ps aux | grep -i'            # Search processes
alias ports='ss -tuln'                  # Show listening ports (ss is modern netstat)
alias top='htop'                        # Better top (if htop is installed)

# Network utilities
alias ping='ping -c 5'                  # Limit ping to 5 packets (prevents endless pinging)
alias myip='curl -s ifconfig.me'        # Get public IP
alias localip='ip route get 1 | awk "{print \$7}"' # Get local IP

# Text processing with colors
alias grep='grep --color=auto'          # Colorized grep
alias fgrep='fgrep --color=auto'        # Fixed-string grep
alias egrep='egrep --color=auto'        # Extended regex grep
alias diff='diff --color=auto'          # Colorized diff

# Development tools
alias vim='nvim'                        # Use neovim (better than vim)
alias v='nvim'                          # Quick vim access
alias py='python3'                      # Python 3 (Fedora default)
alias pip='pip3'                        # Python 3 pip

# Archive handling (common file operations)
alias tgz='tar -czf'                    # Create gzipped tar
alias tgx='tar -xzf'                    # Extract gzipped tar
alias tbz='tar -cjf'                    # Create bzipped tar
alias tbx='tar -xjf'                    # Extract bzipped tar

# ===== POWER USER FUNCTIONS =====

# Create directory and enter it (common workflow)
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files and edit with fzf (if available)
fvim() {
    local file
    file=$(find . -type f -name "*$1*" | fzf --preview 'cat {}' 2>/dev/null) && nvim "$file"
}

# Quick git commit workflow
qcommit() {
    git add . && git commit -m "${1:-Quick commit}" && echo "✅ Changes committed!"
}

# Comprehensive system information
sysinfo() {
    echo "=== 🖥️  Fedora System Information ==="
    echo "Hostname: $(hostname)"
    echo "OS: $(cat /etc/fedora-release)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2 " (" int($3/$2*100) "%)"}')"
    echo "Disk Usage: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
    echo "Active Users: $(who | wc -l)"
    echo "Package Count: $(dnf list installed | wc -l) installed packages"
}

# Universal archive extraction
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.xz)        xz -d "$1"       ;;
            *.rpm)       rpm2cpio "$1" | cpio -idmv ;;  # Fedora-specific
            *)           echo "❌ Cannot extract '$1' - unsupported format" ;;
        esac
    else
        echo "❌ '$1' is not a valid file"
    fi
}

# Quick package search and info
pkginfo() {
    if [ -z "$1" ]; then
        echo "Usage: pkginfo <package_name>"
        return 1
    fi
    echo "=== 📦 Package Information for: $1 ==="
    dnf info "$1" 2>/dev/null || dnf search "$1"
}

# System cleanup function
cleanup() {
    echo "🧹 Starting Fedora system cleanup..."

    # Clean DNF cache
    sudo dnf clean all

    # Remove orphaned packages
    sudo dnf autoremove

    # Clean journal logs older than 2 weeks
    sudo journalctl --vacuum-time=2weeks

    # Clean thumbnail cache
    [ -d ~/.cache/thumbnails ] && rm -rf ~/.cache/thumbnails/*

    # Clean browser cache (if directories exist)
    [ -d ~/.cache/mozilla ] && rm -rf ~/.cache/mozilla/firefox/*/cache2/*
    [ -d ~/.cache/google-chrome ] && rm -rf ~/.cache/google-chrome/Default/Cache/*

    echo "✅ Cleanup completed!"
}

# ===== OPTIONAL ENHANCEMENTS =====

# FZF integration (if available - common on Fedora)
if command -v fzf > /dev/null 2>&1; then
    # Load FZF shell integration
    source /usr/share/fzf/shell/key-bindings.zsh 2>/dev/null

    # Custom FZF configuration for better performance
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS='--preview "cat {}" --preview-window=right:60%:wrap'

    # Useful FZF aliases
    alias ff='fzf --preview "cat {}"'
    alias fcd='cd $(find . -type d | fzf)'
fi

# Auto-suggestions (lightweight enhancement)
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'           # Subtle gray color
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)    # Use both history and completion
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20              # Limit for performance
fi

# Syntax highlighting (optional, can be disabled for better battery)
# Uncomment next line only if you want syntax highlighting (uses more CPU)
# [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===== ENVIRONMENT VARIABLES =====

# XDG Base Directory Specification (Linux standard)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Default applications
export EDITOR='nvim'                    # Default text editor
export VISUAL='code'                    # Visual editor for complex tasks
export PAGER='less'                     # Default pager
export BROWSER='firefox'                # Default web browser
export MANPAGER='less -X'               # Man page viewer

# Development environment
export GOPATH="$HOME/go"                # Go workspace
export CARGO_HOME="$XDG_DATA_HOME/cargo" # Rust cargo home

# Path management (secure and organized)
typeset -U path                         # Remove duplicates from PATH
path=(
    ~/.local/bin                        # User binaries
    ~/.cargo/bin                        # Rust binaries
    ~/go/bin                           # Go binaries
    /var/lib/flatpak/exports/bin       # Flatpak binaries
    ~/.local/share/flatpak/exports/bin # User flatpak binaries
    $path
)

# Less configuration for better man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # Begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # Begin bold
export LESS_TERMCAP_me=$'\E[0m'        # Reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # Begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # Reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # Begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # Reset underline

# ===== LAZY LOADING FOR PERFORMANCE =====
# These tools are loaded only when first used (saves startup time)

# Node.js version manager (lazy load to save ~200ms startup time)
nvm() {
    unfunction nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Create placeholder functions for npm tools
node() { nvm use default; node "$@"; }
npm() { nvm use default; npm "$@"; }
npx() { nvm use default; npx "$@"; }

# Python virtual environment lazy loading
workon() {
    unfunction workon
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh 2>/dev/null
    workon "$@"
}

# ===== CONDITIONAL LOADING (only load what exists) =====

# Local customizations (for machine-specific settings)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Work-specific configurations (keep work stuff separate)
[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work

# Nix package manager (if installed)
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && source ~/.nix-profile/etc/profile.d/nix.sh

# Ruby version manager (if installed)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Conda initialization (if installed)
[[ -f ~/miniconda3/etc/profile.d/conda.sh ]] && source ~/miniconda3/etc/profile.d/conda.sh

# ===== FEDORA-SPECIFIC OPTIMIZATIONS =====

# Enable color support for common commands (uses Fedora's dircolors)
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # Fix ls color for world-writable directories

    # Apply colors to completion system
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Fedora-specific environment optimizations
export HISTCONTROL=ignoreboth           # Don't save duplicates or commands starting with space
export LESSHISTFILE=-                   # Don't save less history (privacy + performance)

# ===== CLEANUP AND FINAL SETUP =====

# Remove setup function to free memory
unset -f setup_prompt

# Performance: compile zshrc if it was modified (speeds up future startups)
if [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi

# Welcome message (comment out for faster startup)
echo "🚀 Fedora power shell ready! Type 'sysinfo' for system status."