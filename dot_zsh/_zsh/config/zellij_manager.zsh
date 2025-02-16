###############################################################################
# zellij_manager.zsh | Multiplexer
# -----------------------------------------------------------------------------

# 1. Define the core session selection logic in a separate function
function zellij_session_handler() {
  [[ -n "$ZELLIJ$TMUX$GNU_SCREEN" ]] && return 0
  
  # Check if zellij has any sessions first
  if ! zellij list-sessions &>/dev/null; then
    # No sessions exist, start a new one
    command zellij
    return
  fi

  local sessions
  sessions=$(zellij list-sessions -s 2>/dev/null)
  
  # Only proceed if we actually got session names
  if [[ -z "$sessions" ]]; then
    command zellij
    return
  fi

  local session_count
  session_count=$(wc -l <<< "$sessions")
  
  if (( session_count == 1 )); then
    # Automatically attach to the single session
    zellij attach "$(echo "$sessions")"
  elif (( session_count > 1 )) && (( ${+commands[fzf]} )); then
    # Use fzf to select from multiple sessions
    local selected_session
    selected_session=$(print -r "$sessions" | fzf --height 40% --reverse --prompt="Select session: ")
    [[ -n "$selected_session" ]] && zellij attach "$selected_session"
  else
    # Fallback to zellij attach if no fzf
    zellij attach
  fi
}
# 2. Create a wrapper function for the 'zellij' command
function zellij() {
  if [[ "$#" -eq 0 ]]; then
    zellij_session_handler
  else
    command zellij "$@"
  fi
}

# 3. Define startup function using the session handler
function zellij_start_if_needed() {
  # Only auto-start if not already in a session
  [[ -n "$ZELLIJ$TMUX$GNU_SCREEN" ]] && return
  [[ ! -t 1 || $- != *i* || "${ZELLIJ_AUTO_START:-}" != true ]] && return
  (( ${+commands[zellij]} )) || return

  if [[ "${ZELLIJ_AUTO_ATTACH:-}" == true ]]; then
    zellij_session_handler
  else
    command zellij
  fi
}

# 4. Get Git indicators without printing anything extraneous
function zellij_get_git_info() {
  local git_status
  local indicators=""
  local branch_name=""
  local repo_name=""

  git_status=$(git status --porcelain=v2 --branch 2>/dev/null) || return

  if [[ -n "$git_status" ]]; then
    branch_name=$(echo "$git_status" | grep '^# branch.head' | cut -d ' ' -f 3)
    repo_name=$(echo "$git_status" | grep '^# branch.worktree' | cut -d ' ' -f 3)
    repo_name=${repo_name:t}  # parse trailing name only

    echo "$git_status" | grep -q '^[12]' && indicators+="*"
    echo "$git_status" | grep -q '^\?' && indicators+="+"

    local ab_line
    ab_line=$(echo "$git_status" | grep '^# branch.ab')
    if [[ -n "$ab_line" ]]; then
      local ahead behind
      ahead=${ab_line% *}; ahead=${ahead##* }
      behind=${ab_line##* }
      [[ $ahead != 0 ]] && indicators+="↑${ahead##+}"
      [[ $behind != 0 ]] && indicators+="↓${behind##+}"
    fi

    echo "${repo_name}:${branch_name}:${indicators}"
  fi
}

# 5. Update the Zellij tab name based on current directory or Git info
function zellij_update_tab_name() {
  local tab_name
  local git_info
  git_info=$(zellij_get_git_info)
  if [[ -n "$git_info" ]]; then
    local repo_name branch_name indicators
    repo_name=${git_info%%:*}
    branch_name=${${git_info#*:}%%:*}
    indicators=${git_info##*:}
    tab_name="${repo_name} [${branch_name}${indicators}]"
  else
    if [[ $PWD == $HOME ]]; then
      tab_name="~"
    elif [[ $PWD == $HOME/* ]]; then
      tab_name="~/${${PWD#$HOME/}:t}"
    else
      tab_name="${PWD:t}"
    fi
  fi

  [[ "$ZELLIJ_LAST_TAB_NAME" != "$tab_name" ]] && {
    command nohup zellij action rename-tab "$tab_name" >/dev/null 2>&1
    ZELLIJ_LAST_TAB_NAME="$tab_name"
  }
}

# 6. Toggle auto-start behavior without spamming output
function toggle_zellij_autostart() {
  if [[ "$ZELLIJ_AUTO_START" == true ]]; then
    ZELLIJ_AUTO_START=false
    echo "Zellij auto-start disabled"
  else
    ZELLIJ_AUTO_START=true
    echo "Zellij auto-start enabled"
  fi
}

# 7. Toggle auto-attach behavior without spamming output
function toggle_zellij_autoattach() {
  if [[ "$ZELLIJ_AUTO_ATTACH" == true ]]; then
    ZELLIJ_AUTO_ATTACH=false
    echo "Zellij auto-attach disabled"
  else
    ZELLIJ_AUTO_ATTACH=true
    echo "Zellij auto-attach enabled"
  fi
}

# 8. Set up hooks
chpwd_functions+=(zellij_update_tab_name)
precmd_functions+=(zellij_update_tab_name)

# 9. Call auto-start
zellij_start_if_needed

# 10. Do initial tab rename
zellij_update_tab_name