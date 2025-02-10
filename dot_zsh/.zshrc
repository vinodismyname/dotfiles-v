###############################################################################
source_if_exists() {
    [[ -f "$1" ]] && source "$1" || echo "Warning: Could not source $1" >&2
}
source_if_exists "$ZSH_CONFIG_FOLDER/config/os_detection.zsh"
source_if_exists "$ZSH_CONFIG_FOLDER/config/pre_zsh.zsh"
###############################################################################
# Helper Function
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ###############################################################################
# # Load core shell settings 
source "$ZSH_CONFIG_FOLDER/config/setopt.zsh"  #opt settings
source "$ZSH_CONFIG_FOLDER/config/zstyles.zsh"  #zstyles

# ###############################################################################
# Completions & Auto-suggestions

# Brazil completion
if [ "$IS_AMZN" = true ]; then
    source_if_exists "$HOME/.brazil_completion/zsh_completion"
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


autoload -Uz compinit
if [[ -f ~/.zcompdump(#qNm-1) ]]; then
  compinit -u
else
  compinit
  touch ~/.zcompdump
fi


###############################################################################
# Manually source other scripts/plugins:
# mise completions
if [[ -f "$HOME/.local/bin/mise" ]]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
    source_if_exists "$HOME/.local/share/mise/completions.zsh"
fi


if [[ -d "$HOMEBREW_PREFIX/share" ]]; then
    plugin_files=(
        "zsh-autosuggestions/zsh-autosuggestions.zsh"
        "powerlevel10k/powerlevel10k.zsh-theme"
    )
    for plugin in "${plugin_files[@]}"; do
        source_if_exists "$HOMEBREW_PREFIX/share/$plugin"
    done
fi

# # personal Powerlevel10k config:
source_if_exists "$HOME/.p10k.zsh"
###############################################################################

# Carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)


# FZF Configuration
source_if_exists "$ZSH_CONFIG_FOLDER/config/fzf_config.zsh"
source_if_exists "$ZSH_CONFIG_FOLDER/config/fzf_tab_config.zsh"
###############################################################################
# Aliases and custom zsh fuctions
# source aliases
source_if_exists "$ZSH_CONFIG_FOLDER/config/aliases.zsh"
# source function to browse and cd into workspace directories
if [ "$IS_AMZN" = true ]; then
source_if_exists "$ZSH_CONFIG_FOLDER/functions/brazil_workspace_switcher.zsh"
fi
# source function to select aws profiles with fzf
source_if_exists "$ZSH_CONFIG_FOLDER/functions/aws_profile_switcher.zsh"

##############################################################################
#source syntax higlighting 
source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#Source Zellij Manager near the end
export ZELLIJ_AUTO_START=false
export ZELLIJ_AUTO_ATTACH=false
source "$ZSH_CONFIG_FOLDER/config/zellij_manager.zsh"

