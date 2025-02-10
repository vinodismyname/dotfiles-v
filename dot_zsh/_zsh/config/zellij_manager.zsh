# -----------------------------------------------------------------------------
# zellij_manager.zsh
# -----------------------------------------------------------------------------
# Zellij Integration for Zsh + p10k
# -----------------------------------------------------------------------------

# 1. Define all functions unconditionally
function zellij_start_if_needed() {
  # Only auto-start if not already in a session
  [[ -n "$ZELLIJ$TMUX$GNU_SCREEN" ]] && return
  [[ ! -t 1 || $- != *i* || "${ZELLIJ_AUTO_START:-}" != true ]] && return
  (( ${+commands[zellij]} )) || return

  if [[ "${ZELLIJ_AUTO_ATTACH:-}" == true ]]; then
    local sessions
    sessions=$(zellij list-sessions -s 2>/dev/null) || return
    if [[ -n "$sessions" ]]; then
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
        # Fallback to zellij attach if no fzf or no sessions found after filtering (shouldn't happen)
        zellij attach
      fi
    else
      zellij
    fi
  else
    zellij
  fi
}

# 2. Get Git indicators without printing anything extraneous.
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

# 3. Update the Zellij tab name based on current directory or Git info.
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

# 4. Toggle auto-start behavior without spamming output.
function toggle_zellij_autostart() {
  if [[ "$ZELLIJ_AUTO_START" == true ]]; then
    ZELLIJ_AUTO_START=false
    echo "Zellij auto-start disabled"
  else
    ZELLIJ_AUTO_START=true
    echo "Zellij auto-start enabled"
  fi
}

# 5. Toggle auto-attach behavior without spamming output.
function toggle_zellij_autoattach() {
  if [[ "$ZELLIJ_AUTO_ATTACH" == true ]]; then
    ZELLIJ_AUTO_ATTACH=false
    echo "Zellij auto-attach disabled"
  else
    ZELLIJ_AUTO_ATTACH=true
    echo "Zellij auto-attach enabled"
  fi
}

# 2. Always add the update function to chpwd_functions
chpwd_functions+=(zellij_update_tab_name)
precmd_functions+=(zellij_update_tab_name)


# 3. Actually call auto-start
zellij_start_if_needed

# 4. Do an initial tab rename
zellij_update_tab_name