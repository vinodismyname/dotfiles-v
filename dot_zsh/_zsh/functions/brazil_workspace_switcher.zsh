_brazil_workspace_switcher() {
  local BASE_DIR="$(realpath "${HOME}/workplace")"
  [[ ! -d "$BASE_DIR" ]] && { echo "Base directory not found: $BASE_DIR"; return 1; }

  # Common fd options
  local fd_opts=(
    --max-depth 1
    --type d
    --exclude '.*'
    --absolute-path
  )

  local items=()
  
  # Get all workspaces and their codebases
  local workspaces=($(fd . "$BASE_DIR" ${fd_opts[@]}))
  for dir in ${workspaces}; do
    local workspace_name="$(basename "$dir")"
    items+=($'+ '"${workspace_name}"$'\t'"Workspace"$'\t'"${dir}")
    
    # Get codebases for current workspace
    local codebases=($(fd . "$dir/src" ${fd_opts[@]}))
    local last_idx=$((${#codebases[@]} - 1))
    
    local i=0
    for codebase_dir in ${codebases}; do
      local codebase_name="$(basename "$codebase_dir")"
      local prefix=$'├── '
      [[ $i -eq $last_idx ]] && prefix=$'└── '
      
      items+=("${prefix}${codebase_name}"$'\t'"Codebase"$'\t'"${codebase_dir}")
      ((i++))
    done
  done

  [[ ${#items[@]} -eq 0 ]] && { echo "No workspaces or codebases found in $BASE_DIR"; return 1; }

  # FZF styling options
local fzf_opts=(
  --height '50%'
  --border 'rounded'
  --delimiter $'\t'
  --with-nth=1
  --preview '
    dir="$(echo {} | awk -F"\t" "{print \$3}")"
    preview_content=""

    # ANSI color codes
    BOLD="\033[1m"
    RESET="\033[0m"
    HEADER_COLOR="\033[34m"       # Blue
    SEPARATOR_COLOR="\033[90m"    # Bright Black (Gray)

    append_header() {
      local header="$1"
      local emoji=""
      case "$header" in
        "\src") emoji="📂" ;;
        "\lib") emoji="📚" ;;
        "Others") emoji="📁" ;;
        *) emoji="🔍" ;;
      esac
      preview_content+="${BOLD}${HEADER_COLOR}${emoji} ${header}${RESET}\n"
    }

    append_separator() {
      preview_content+="${SEPARATOR_COLOR}──────────────────────────────────${RESET}\n"
    }

    append_dir_content() {
      local subdir="$1"
      local label="$2"
      if [ -d "$dir/$subdir" ]; then
        append_header "$label"
        # preview_content+="$(eza --color=always --group-directories-first --icons --tree --level=1 "$dir/$subdir" | sed "1d")\n"
        preview_content+="\t$(eza --color=always --group-directories-first --icons --grid -x --level=1 "$dir/$subdir" )\n"
      fi
    }

    # Expand 'src' and 'lib' if they exist
    append_dir_content "src" "\src"
    append_dir_content "lib" "\lib"

    # Show other top-level items excluding 'src' and 'lib'
    append_separator
    append_header "Others"
    preview_content+="\t$(eza --color=always --group-directories-first --icons --grid -x "$dir" --ignore-glob "src|lib")\n"

    echo -e "$preview_content"
  '
  --preview-window 'right:70%:wrap'
  --header 'Brazil Workspaces and Packages // CTRL-C to cancel'
  --color 'header:italic:yellow'
  --color 'fg:white'
  --color 'fg+:white:bold'
  --color 'pointer:yellow'
)

  local selected
  selected="$(printf '%s\n' "${items[@]}" | fzf ${fzf_opts[@]})"
  
  # Early return for empty selection or separators
  [[ -z "$selected" || "$selected" =~ ^[│├└]$ ]] && return 0
  
  local target_path="$(echo "$selected" | awk -F'\t' '{print $3}')"
  [[ ! -d "$target_path" ]] && { echo "Error: Selected directory no longer exists"; return 1; }
  
  cd "$target_path" && echo "$(tput setaf 2)Brazil workspace switching to:$(tput sgr0) $(tput setaf 6)${target_path}$(tput sgr0)" || { 
    echo "Error: Failed to cd into $target_path"
    return 1
  }
}

#lazy load
function bcd() {
  unfunction bcd
  alias bcd="_brazil_workspace_switcher"
  _brazil_workspace_switcher "$@"
}
