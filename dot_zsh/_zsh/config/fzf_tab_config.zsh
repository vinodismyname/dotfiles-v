
# FZF-TAB CONFIGURATION

FZF_TAB_DEFAULT_OPTS="${FZF_DEF_COLOR_OPTS} ${FZF_DEF_LAYOUT_OPTS} ${FZF_DEF_HEADER}"

# Convert the combined string into an array respecting --flags
typeset -a FZF_OPTS_ARRAY
FZF_OPTS_ARRAY=()
for opt in ${(z)FZF_TAB_DEFAULT_OPTS}; do
    if [[ $opt == --* ]]; then
        FZF_OPTS_ARRAY+=($opt)
    else
        # Append non-flag text (like arguments) to the last array element
        FZF_OPTS_ARRAY[-1]="${FZF_OPTS_ARRAY[-1]} $opt"
    fi
done

zstyle ":fzf-tab:*" fzf-flags \
    --multi \
    -- ${FZF_OPTS_ARRAY} \
    --bind 'alt-a:select-all' \
    --bind 'alt-t:toggle-all' \
    --height="80%" \
    --header="<Ctrl-/> Toggle preview    <Ctrl-S/> Sort" \
    --color="header:italic" \
    --bind="ctrl-s:toggle-sort" \
    --bind 'alt-/:change-preview-window:right|down' \
    --bind 'ctrl-/:toggle-preview' \
    --preview-window='right:70%:wrap'

# Accept line with enter
zstyle ':fzf-tab:*' accept-line enter

# Additional fzf-tab features
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' continuous-trigger '/'

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always --git --level=2 $realpath | head -100'

# switch group using `<` and `>` (instead of F1, F2)
zstyle ':fzf-tab:*' switch-group '<' '>'

source "$HOME/_zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "$HOME/_zsh/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh"
