# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Fedora's zsh package runs compinit globally, this prevents duplicate execution
skip_global_compinit=1
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh



# History configuration - optimized for power users
HISTSIZE=60000          # Keep 100k commands in memory (balance between utility and RAM usage)
SAVEHIST=20000         # Save 50k to disk (reduces I/O operations, better for SSDs)
HISTFILE=~/.zsh_history # Standard location, works with Fedora's default setup

# Essential history options (each saves CPU cycles and improves UX)
setopt HIST_IGNORE_DUPS      # Don't record duplicate consecutive commands (reduces history bloat)
setopt HIST_IGNORE_SPACE     # Commands starting with space aren't recorded (useful for sensitive commands)
setopt HIST_EXPIRE_DUPS_FIRST # When trimming history, remove duplicates first (keeps unique commands longer)
setopt HIST_SAVE_NO_DUPS     # Don't save duplicate commands to history file (reduces disk I/O)
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching history (cleaner search results)
setopt HIST_REDUCE_BLANKS    # Remove extra blanks from commands before recording (cleaner history)
setopt appendhistory      # Append new commands to history file (not overwrite)
setopt incappendhistory   # Write commands immediately (real-time)
setopt sharehistory       # Share history between all open shells
setopt extended_history   # Record timestamps with commands
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
# setopt CORRECT              # Suggest corrections for mistyped commands (helps with typos)
setopt COMPLETE_IN_WORD     # Complete from cursor position, not just end (better completion UX)
setopt ALWAYS_TO_END        # Move cursor to end after completion (consistent behavior)
# setopt HASH_LIST_ALL        # Hash entire command path on first execution (faster subsequent runs)

# Word separators optimized for path navigation and development
# Removes / and . from word characters so Ctrl+W stops at path components
WORDCHARS=${WORDCHARS//\/[&.;]}

 
autoload -U colors && colors  # Load color support (standard zsh feature)


# Enable real-time syntax highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Auto-suggestions (lightweight enhancement)
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'           # Subtle gray color
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)    # Use both history and completion
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20              # Limit for performance
fi

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

# # Git workflow (essential for developers)
# alias g='git'                           # Quick git access
# alias ga='git add'                      # Stage files
# alias gaa='git add --all'               # Stage all changes
# alias gc='git commit -m'                # Commit with message
# alias gca='git commit --amend'          # Amend last commit
# alias gco='git checkout'                # Switch branches
# alias gcb='git checkout -b'             # Create and switch to new branch
# alias gd='git diff'                     # Show differences
# alias gdc='git diff --cached'           # Show staged differences
# alias gl='git log --oneline --graph --decorate --all' # Pretty log
# alias gp='git push'                     # Push changes
# alias gpu='git pull'                    # Pull changes
# alias gs='git status -sb'               # Short status
# alias gst='git stash'                   # Stash changes
# alias gstp='git stash pop'              # Apply stash

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
alias vf='code ~/CODEWITHVENKY/C++/codeforces/'
alias cf='vim ~/CODEWITHVENKY/C++/codeforces/'
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

export PATH=$PATH:~/.local/bin

# pnpm
export PNPM_HOME="/home/venky/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export QT_QPA_PLATFORMTHEME=qt6ct
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/snap/bin

# bun completions
[ -s "/home/venky/.bun/_bun" ] && source "/home/venky/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/venky/google-cloud-sdk/path.zsh.inc' ]; then . '/home/venky/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/venky/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/venky/google-cloud-sdk/completion.zsh.inc'; fi
