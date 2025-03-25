###############################################################################
## Ensure VSCode is in path if active
if [[ -n "${VSCODE_GIT_ASKPASS_NODE}" ]]; then
    export PATH=$(dirname ${VSCODE_GIT_ASKPASS_NODE})/bin/remote-cli:${PATH}
fi

#------------------------------------------------------------------------------
# Helper Function

typeset -g POWERLEVEL9K_INSTANT_PROMPT
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#------------------------------------------------------------------------------
# Load core shell settings 
source "${ZSH_CONFIG_FOLDER}/config/setopt.zsh"  #opt settings
source "${ZSH_CONFIG_FOLDER}/config/zstyles.zsh"  #zstyles


#------------------------------------------------------------------------------
# Completions & Auto-suggestions

# Create Cache and Compile completions
autoload -Uz compinit
zsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$zsh_cache"
zcompdump="$zsh_cache/zcompdump"
if [[ -f "$zcompdump"(#qNm-1) ]]; then
  compinit -u -d "$zcompdump"
else
  compinit -d "$zcompdump"
  touch "$zcompdump"
fi

# UV/UVX completion
if command -v uv >/dev/null; then
    eval "$(uv generate-shell-completion zsh)"
fi
if command -v uvx >/dev/null; then
    eval "$(uvx --generate-shell-completion zsh)"
fi

# zoxide
eval "$(zoxide init zsh)"
# atuin
eval "$(atuin init zsh)"
# direnv
eval "$(direnv hook zsh)"

if [[ -f "$HOME/.local/bin/mise" ]]; then
    "$HOME/.local/bin/mise" completions zsh > "$HOME/.local/share/mise/completions.zsh"
    source_if_exists "$HOME/.local/share/mise/completions.zsh"
fi

#------------------------------------------------------------------------------
# Homebrew Plugins
if [[ -d "$HOMEBREW_PREFIX/share" ]]; then
    plugin_files=(
        "zsh-autosuggestions/zsh-autosuggestions.zsh"
        "powerlevel10k/powerlevel10k.zsh-theme"
    )
    for plugin in "${plugin_files[@]}"; do
        source_if_exists "$HOMEBREW_PREFIX/share/$plugin"
    done
fi

#------------------------------------------------------------------------------
# personal Powerlevel10k config:
source_if_exists "$HOME/.p10k.zsh"


# Carapace completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)
eval "$(~/.local/bin/mise activate zsh)"

#------------------------------------------------------------------------------
# Aliases and Custom zsh fuctions
# FZF Configuration
source_if_exists "${ZSH_CONFIG_FOLDER}/config/fzf_config.zsh"
source_if_exists "${ZSH_CONFIG_FOLDER}/config/fzf_tab_config.zsh"

# source aliases
source_if_exists "${ZSH_CONFIG_FOLDER}/config/aliases.zsh"
# source function to browse and cd into workspace directories
if [ "$IS_AMZN" = true ]; then
source_if_exists "${ZSH_CONFIG_FOLDER}/functions/brazil_workspace_switcher.zsh"
fi
# source function to select aws profiles with fzf
source_if_exists "${ZSH_CONFIG_FOLDER}/functions/aws_profile_switcher.zsh"


#------------------------------------------------------------------------------
#source syntax higlighting 
source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#------------------------------------------------------------------------------
#Source Zellij Manager

#whether Zellij should automatically launch when opening a new terminal
export ZELLIJ_AUTO_START=false

#whether to attach to existing sessions instead of creating new ones
export ZELLIJ_AUTO_ATTACH=true
source "${ZSH_CONFIG_FOLDER}/config/zellij_manager.zsh"

###############################################################################

