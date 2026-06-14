###############################################################################
#------------------------------------------------------------------------------
#load helpers
skip_global_compinit=1
export ZSH_CONFIG_FOLDER=$(readlink -f "$HOME/_zsh")
source_if_exists() {
    [[ -f "$1" ]] && source "$1" || echo "Warning: Could not source $1" >&2
}

export IS_AMZN=false
if command -v mwinit &>/dev/null; then
  export IS_AMZN=true
fi

#------------------------------------------------------------------------------
#histfile
export HISTFILE=~/.history
export HISTSIZE=50000
export SAVEHIST=50000

#------------------------------------------------------------------------------
# Pager and display settings
export PAGER=less
export MANPAGER=less
export LESS='-R'

#------------------------------------------------------------------------------
# Editor settings
export EDITOR="hx"
export VISUAL="$EDITOR"

#------------------------------------------------------------------------------
# Bat Configuration
export BAT_THEME="DarkNeon"
export BAT_STYLE="numbers"
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

#------------------------------------------------------------------------------
#Go Configuration
export GOPATH=$HOME/go
export GOPROXY=direct

#------------------------------------------------------------------------------
#Credentials URI for Chat
export AWS_CONTAINER_CREDENTIALS_FULL_URI=http://127.0.0.1:9911

#------------------------------------------------------------------------------
#Homebrew Configuration
export HOMEBREW_PREFIX="/opt/homebrew"

export HOMEBREW_CELLAR=${HOMEBREW_PREFIX}/Cellar
export HOMEBREW_REPOSITORY=${HOMEBREW_PREFIX}/Homebrew
if [[ -f "$HOMEBREW_PREFIX/bin/brew" ]]; then
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

#------------------------------------------------------------------------------
# SST Variables

export SST_SSH_PRIVATE_KEY_FULL_PATH='/Users/vinoddu/vinod-sst'
export SST_SSH_KEY_FULL_PATH='/Users/vinoddu/vinod-sst.pub'

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


typeset -U path  # Ensure unique entries
paths_to_prepend=(
  "$HOME/.cargo/bin"
  "$HOME/.toolbox/bin"
  "$HOME/.local/bin"
  "$HOME/bin"
  "/usr/local/bin"
  "/Users/vinoddu/bin"
  "/Users/vinoddu/.local/bin"
  "/opt/homebrew/bin"
  "$(ruby -e 'puts Gem.bindir' 2>/dev/null)"
  "$GOPATH/bin"
)

for p in "${paths_to_prepend[@]}"; do
  if [[ -d "$p" ]]; then
    path=("$p" $path)
  fi
done
###############################################################################
# uv
export PATH="/Users/vinoddu/.local/bin:$PATH"
