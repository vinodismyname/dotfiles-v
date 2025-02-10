# FZF + FZF-TAB UNIFIED CONFIG

# -----------------------------------------------------------------------------
# 1. THEME
# -----------------------------------------------------------------------------
fg="#FFFFFF"
bg=""
bg_plus="#333333"
accent="#FFD700"
highlight="#FF4500"

FZF_COLORS=(
    "fg:${fg}"
    "bg:${bg}"
    "hl:${highlight}"
    "fg+:${fg}"
    "bg+:${bg_plus}"
    "hl+:${highlight}"
    "info:${accent}"
    "prompt:${accent}"
    "pointer:${accent}"
    "marker:${accent}"
    "spinner:${accent}"
    "header:${accent}"
)

FZF_COLORS_STRING=$(printf ",%s" "${FZF_COLORS[@]}")
FZF_COLORS_STRING=${FZF_COLORS_STRING:1}

# Build the color option for FZF
FZF_DEF_COLOR_OPTS="--color=${FZF_COLORS_STRING}"

# More visible header
FZF_DEF_HEADER_TEXT="CTRL-/ to toggle preview"
FZF_DEF_HEADER="--header='$FZF_DEF_HEADER_TEXT'"

# Layout with standard border, 60% height, reverse listing
FZF_DEF_LAYOUT_OPTS="--height=60% --layout=reverse --inline-info"

# Combine default options
export FZF_DEFAULT_OPTS="${FZF_DEF_COLOR_OPTS} ${FZF_DEF_LAYOUT_OPTS} ${FZF_DEF_HEADER}"

# -----------------------------------------------------------------------------
# 2. PREVIEW SETTINGS & FALLBACK COMMANDS
# -----------------------------------------------------------------------------
HEAD_LINES_LONG=200
HEAD_LINES_SHORT=100

# If 'eza' is not available, you might switch to 'ls -lR' or 'lsd --tree', etc.
PREVIEW_LIST_CMD="eza --tree --color=always"
PREVIEW_FILE_CMD="bat --style=numbers --color=always"

function preview_markdown() {
    # If glow is installed, use it; otherwise fallback to bat
    if command -v glow &>/dev/null; then
        echo "glow -s dark {}"
    else
        echo "$PREVIEW_FILE_CMD {}"
    fi
}

# -----------------------------------------------------------------------------
# 3. UNIVERSAL PREVIEW CMD FOR FZF (not fzf-tab)
# -----------------------------------------------------------------------------
export FZF_PREVIEW_CMD='
    if [[ -d {} ]]; then
        '"$PREVIEW_LIST_CMD"' "{}" | head -n '"$HEAD_LINES_LONG"'
    elif [[ -f {} ]]; then
        case "$(file --mime-type "{}" -b)" in
            text/*|application/json|application/javascript)
                '"$PREVIEW_FILE_CMD"' "{}" ;;
            text/markdown)
                '"$(preview_markdown)"' ;;
            *)
                file -b "{}" ;;
        esac
    fi
'

# -----------------------------------------------------------------------------
# 4. PREVIEW WINDOWS
# -----------------------------------------------------------------------------
export FZF_PREVIEW_WINDOW_LONG="right:60%:wrap:border-left"
export FZF_PREVIEW_WINDOW_SHORT="up:3:hidden:wrap"

# -----------------------------------------------------------------------------
# 5. SETUP FZF FUNCTION
# -----------------------------------------------------------------------------
setup_fzf() {
    local required_deps=(fzf bat eza delta glow)
    local missing_deps=()

    for dep in "${required_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Warning: Missing dependencies: ${missing_deps[*]}"
        echo "Some features may degrade or not work."
    fi

    if ! command -v fzf &>/dev/null; then
        return
    fi

    # Example excludes for fd
    local EXCLUDES="--exclude .brazil --exclude node_modules --exclude .venv"

    # Default search commands
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix $EXCLUDES"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --strip-cwd-prefix $EXCLUDES"

    # CTRL-T
    export FZF_CTRL_T_OPTS="
        --preview '${FZF_PREVIEW_CMD}'
        --preview-window '${FZF_PREVIEW_WINDOW_LONG}'
        --multi
        --bind 'ctrl-a:toggle-all'
        --header 'TAB/SHIFT-TAB select, CTRL-A toggle all'
    "

    # ALT-C
    export FZF_ALT_C_OPTS="
        --preview '${PREVIEW_LIST_CMD} {} | head -n ${HEAD_LINES_LONG}'
        --preview-window '${FZF_PREVIEW_WINDOW_LONG}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'
        --header 'CTRL-/ to toggle preview'
    "

    # CTRL-R
    export FZF_CTRL_R_OPTS="
        --preview 'echo {}'
        --preview-window '${FZF_PREVIEW_WINDOW_SHORT}'
        --bind '?:toggle-preview'
        --header '? toggle preview'
    "

    # Example fzf run completions for different commands
    _fzf_comprun() {
        local command="$1"
        shift
        case "$command" in
            cd)
                fzf --preview "${PREVIEW_LIST_CMD} {} | head -n ${HEAD_LINES_LONG}" "$@"
                ;;
            export|unset)
                fzf --preview "eval 'echo \${}'" "$@"
                ;;
            ssh)
                fzf --preview 'dig {} || host {}' "$@"
                ;;
            vim|nvim)
                fzf --preview "${PREVIEW_FILE_CMD} {}" "$@"
                ;;
            man)
                fzf --preview 'man -Pcat {} 2>/dev/null' "$@"
                ;;
            *)
                fzf --preview "${FZF_PREVIEW_CMD}" "$@"
                ;;
        esac
    }

    # Initialize FZF key bindings for zsh
    eval "$(fzf --zsh)"
}

setup_fzf
