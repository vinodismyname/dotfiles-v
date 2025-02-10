###############################################################################
source_if_exists() {
    [[ -f "$1" ]] && source "$1" || echo "Warning: Could not source $1" >&2
}
source_if_exists "$HOME/.zsh/config/os_detection.zsh"

source_if_exists "$HOME/.zsh/config/pre_zsh.zsh"
###############################################################################
# cloud desktop setup envImprovement
if [ "$IS_LINUX" = true ]; then
    local ZSH=/apollo/env/envImprovement/bin/zsh

    if [[ ${SHELL} != ${ZSH} && -e ${ZSH} ]]; then
    typeset -g SHELL=${ZSH}
    exec ${ZSH} -${-} "${@}"
    fi

    unset ZSH

    if [[ -n "${VSCODE_GIT_ASKPASS_NODE}" ]]; then
        export PATH=$(dirname ${VSCODE_GIT_ASKPASS_NODE})/bin/remote-cli:${PATH}
    fi

fi

# Helper Function
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ###############################################################################
# # Load core shell settings 

source "$HOME/_zsh/config/setopt.zsh"  #opt settings
source "$HOME/_zsh/config/zstyles.zsh"  #zstyles

# ###############################################################################
# Completions & Auto-suggestions

# Brazil completion
if [ "$IS_AMZN" = true ] then;
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
source_if_exists "$HOME/_zsh/fzf_config.zsh"
source_if_exists "$HOME/_zsh/fzf_tab_config.zsh"
###############################################################################
# Aliases and custom zsh fuctions
# source aliases
source_if_exists "$HOME/_zsh/config/aliases.zsh"
# source function to browse and cd into workspace directories
source_if_exists "$HOME/_zsh/functions/brazil_workspace_switcher.zsh"
# source function to select aws profiles with fzf
source_if_exists "$HOME/_zsh/functions/aws_profile_switcher.zsh"

##############################################################################
#(Optional) Source Zellij Manager near the end
export ZELLIJ_AUTO_START=false
export ZELLIJ_AUTO_ATTACH=false
source "$HOME/_zsh/config/zellij_manager.zsh"

#last: source syntax higlighting 
source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"