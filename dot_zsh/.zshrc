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
export ZELLIJ_AUTO_ATTACH=false
source "${ZSH_CONFIG_FOLDER}/config/zellij_manager.zsh"

###############################################################################
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export AWS_CONTAINER_CREDENTIALS_FULL_URI=http://127.0.0.1:991
zshrc_local="$HOME/_dotfiles/dot_zsh/.zshrc.local"
[[ -r "$zshrc_local" ]] && source "$zshrc_local"
unset zshrc_local
# pnpm
export PNPM_HOME="/Users/vinoddu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


eval "$(/opt/homebrew/bin/brew shellenv)"

# bun completions
[ -s "/Users/vinoddu/.bun/_bun" ] && source "/Users/vinoddu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.yarn/bin"

source_if_exists /Users/vinoddu/.brazil_completion/zsh_completion

# Added by MultiQ installer
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/_dotfiles/dot_zsh/.p10k.zsh.
[[ ! -f ~/_dotfiles/dot_zsh/.p10k.zsh ]] || source ~/_dotfiles/dot_zsh/.p10k.zsh

# Added by smithy-mcp
export PATH="$HOME/.config/smithy-mcp/mcp-servers:$PATH"

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

# MeshClaw
export PATH="/Volumes/workplace/meshclaw-ws/src/CibelesMeshClaw/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
