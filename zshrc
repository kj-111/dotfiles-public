# ---- CORE SETTINGS ----
bindkey -e  # Emacs mode
stty -ixon  # Ctrl+S werkt (disable flow control)

setopt promptsubst INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_VERIFY AUTO_CD NOMATCH

# Path & History
path=(
  $HOME/bin
  $HOME/.local/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  $path
)
export PATH
export HISTFILE=~/.zsh_history HISTSIZE=20000 SAVEHIST=20000

# Editor: nvr als we in Neovim terminal zitten, anders nvim
if [[ -n "$NVIM" ]]; then
  export EDITOR="nvr --remote-wait-silent"
  export GIT_EDITOR="nvr --remote-wait-silent"
  alias nvim="nvr --remote-silent"
else
  export EDITOR="nvim"
fi

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
alias lg='lazygit' dash='dashboard'
alias sr='/opt/homebrew/bin/sketchybar --reload'
alias yt='~/.local/venvs/yt-dlp/bin/yt-dlp'
alias pdf='open -a Preview'

# ---- FUNCTIONS ----
r() { source ~/.zshrc; }

# Search files
ff() {
  local f=$(fzf --preview 'cat {}')
  [[ -n "$f" ]] && nvim "$f"
}

# Compress PDF: shrink input.pdf → input-compressed.pdf
shrink() {
  [[ -z "$1" ]] && echo "Usage: shrink file.pdf" && return 1
  local out="${1%.pdf}-compressed.pdf"
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
     -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$out" "$1" && \
  echo "$(du -h "$1" | cut -f1) -> $(du -h "$out" | cut -f1): $out"
}

# ---- INIT ----
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"
