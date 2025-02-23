###############################################################################
#------------------------------------------------------------------------------
#load helpers
skip_global_compinit=1
export ZSH_CONFIG_FOLDER=$(readlink -f "$HOME/_zsh")
source_if_exists() {
    [[ -f "$1" ]] && source "$1" || echo "Warning: Could not source $1" >&2
}
source_if_exists "${ZSH_CONFIG_FOLDER}/config/os_detection.zsh"

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
export EDITOR="nvim"
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
#Homebrew Configuration
if [ "$IS_LINUX" = true ]; then 
  export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
elif [ "$IS_MAC" = true ]; then 
  export HOMEBREW_PREFIX="/opt/homebrew"
fi

export HOMEBREW_CELLAR=${HOMEBREW_PREFIX}/Cellar
export HOMEBREW_REPOSITORY=${HOMEBREW_PREFIX}/Homebrew
if [[ -f "$HOMEBREW_PREFIX/bin/brew" ]]; then
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

#------------------------------------------------------------------------------
# Linux Specific Configuration
if [ "$IS_LINUX" = true ] && [ "$IS_AMZN" = true ]; then
  # AWS Configuration
  export AWS_EC2_METADATA_DISABLED=true
  export EXPAND_HOSTCLASS_COMPLETION_FILE=~/.hostclasses
  # Basic environment settings
  export LC_ALL=en_US.UTF-8
  export TERM="xterm-256color"

  export EDA_AUTO="$HOME/.config/eda/completion"
  mkdir -p "$EDA_AUTO"
  export BRAZIL_WORKPLACE="/local/workplace/$USER"
  export BRAZIL_WORKSPACE_DEFAULT_LAYOUT="short"
  export BRAZILPYTHON_FAST_FAIL=true
  export BRAZILPYTHON_ERROR_FORMAT=short
  export BRAZIL_COLORS=true
  export BRAZIL_USE_PARALLEL_SYNCING=1


  if [ "$HAS_NVIDIA" = true ]; then
    # CUDA/torch Configuration
    if [[ -d "/usr/local/cuda-12.4" ]]; then
        export CUDA_HOME="/usr/local/cuda-12.4"
        export CUDA_VISIBLE_DEVICES=0,1,2,3,5,6,7
        export LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
    fi
    export CC=/usr/bin/gcc10-cc
    export CXX=/bin/gcc10-c++
    export TORCH_CUDA_ARCH_LIST="7.0"
  fi

  # Path Configuration
  typeset -U FPATH fpath PATH path MANPATH manpath MODULE_PATH module_path

  fpath=(
      /apollo/env/envImprovement/var/zsh/functions/*(om[1])
      /apollo/env/envImprovement/var/share/zsh/*{,/functions,site-functions}
      /usr/share/zsh/site-functions
      /home/linuxbrew/.linuxbrew/share/zsh/site-functions
      $EDA_AUTO
      $fpath
  )

  path=(
      /bin
      ${CUDA_HOME}/bin
      /usr/bin/gcc
      ~/bin
      ~/.{cargo,local,toolbox}/bin
      ${HOMEBREW_PREFIX}/{,s}bin
      ${GOPATH}/bin
      /usr/local/sessionmanagerplugin/bin
      /apollo/env/envImprovement/bin
      /{,usr/}{,s}bin
      /apollo/env/*/bin
      $path
  )

  manpath=(
    /apollo/env/envImprovement/{,share/}man
    /home/linuxbrew/.linuxbrew/share/man
    /usr/kerberos/man
    $manpath
  )

  module_path=(
    /usr/lib64/zsh/${ZSH_VERSION}(N)
    /apollo/env/envImprovement/var/lib/zsh/${ZSH_VERSION}(N)
    $module_path
  )

fi

#------------------------------------------------------------------------------
# Mac Specific Configuration
if [ "$IS_MAC" = true ];
then export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

 if [ "$IS_AMZN" = true ]; then
  typeset -U path  # Ensure unique entries
  paths_to_prepend=(
    "$HOME/.cargo/bin"
    "$HOME/.toolbox/bin"
    "$HOME/.local/bin"
    "$HOME/bin"
    "/opt/homebrew/bin"
    "/home/linuxbrew/.linuxbrew/bin"
    "$(ruby -e 'puts Gem.bindir' 2>/dev/null)"
    "$GOPATH/bin"
  )

  for p in "${paths_to_prepend[@]}"; do
    if [[ -d "$p" ]]; then
      path=("$p" $path)
    fi
  done
fi
fi
###############################################################################