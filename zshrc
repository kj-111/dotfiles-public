# ---- CORE SETTINGS ----
bindkey -e  # Emacs mode

setopt promptsubst INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_VERIFY AUTO_CD NOMATCH

# Path & History
path=(
  $HOME/bin
  $HOME/.cargo/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  $path
)
export PATH
export HISTFILE=~/.zsh_history HISTSIZE=20000 SAVEHIST=20000
export EDITOR="nvim"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# ---- COMPLETION & FZF ----
autoload -Uz compinit colors; compinit -i; colors
zstyle ':completion:*' menu select

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'

# Load FZF scripts
source /opt/homebrew/opt/fzf/shell/completion.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# ---- ALIASES ----
# Navigation
alias ..='cd ..'
alias h='history' c='clear' q='exit'

# Tools
alias grep='grep --color=auto' df='df -h' du='du -h'
alias as='aerospace'
alias lg='lazygit' gitd='git-dashboard' dash='dashboard'
alias sr='/opt/homebrew/bin/sketchybar --reload'
alias yt='~/.local/venvs/yt-dlp/bin/yt-dlp'
alias pdf='tdf'

# ---- FUNCTIONS ----
r() { source ~/.zshrc; }

# Search files (ff) or content (ffg)
ff() { 
  local f=$(fzf --preview 'cat {}')
  [[ -n "$f" ]] && nvim "$f"
}

ffg() { 
  fzf --disabled --ansi --query "$1" \
    --bind "start:reload:rg --column --line --no-heading --color=always --smart-case {q}" \
    --bind "change:reload:rg --column --line --no-heading --color=always --smart-case {q} || true" \
    --preview 'cat {1}' \
    --bind 'enter:execute(nvim +{2} {1})+abort'
}

# Fast directory jump
ffd() { 
  local d=$(fd -t d . ${1:-.} | fzf)
  [[ -n "$d" ]] && cd "$d"
}

# Fuzzy find through docs and open in nvim
ffh() {
  local f=$(fd . ~/.config/docs | fzf --preview 'cat {}')
  [[ -n "$f" ]] && nvim "$f"
}

# Fuzzy find PDF and open in tdf
ffp() {
  local f=$(fd -t f -e pdf . | fzf)
  [[ -n "$f" ]] && tdf "$f"
}

# ---- INIT ----
eval "$(zoxide init zsh)"
PROMPT='%F{4}%~%f %F{6}${$(git rev-parse --abbrev-ref HEAD 2>/dev/null):-}%f %F{3}>%f '
export PATH="$HOME/.local/bin:$PATH"
