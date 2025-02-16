#!/usr/bin/env bash


PRIMARY=51      # Bright cyan (#00ffff) 
HEADING=213     # Bright magenta (#ff87ff)
SUBHEADING=123  # Light cyan (#87ffff)
SUCCESS=120     # Bright green (#87ff87)
WARNING=228     # Bright yellow (#ffff87)
ERROR=204       # Bright coral (#ff5f87) 
INFO=117        # Light blue (#87d7ff)
DIM=244         # Medium gray (#808080)

### Unicode Characters
CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW_RIGHT="→"
INFO_SYMBOL="•"

### Styling Functions
heading() {
    gum style --foreground "$HEADING" --bold "$ARROW_RIGHT $1"
    gum style --foreground "$DIM" "$(printf '━%.0s' $(seq 1 50))"
}

subheading() {
    echo
    gum style --foreground "$SUBHEADING" "  $ARROW_RIGHT $1"
    gum style --foreground "$DIM" "  $(printf '─%.0s' $(seq 1 40))"
    echo
}

divider() {
    echo
    gum style --foreground "$DIM" "$(printf '┄%.0s' $(seq 1 50))"
    echo
}

### Message Functions
success_msg() {
    gum style --foreground "$SUCCESS" "  $CHECK_MARK $1"
}

error_msg() {
    gum style --foreground "$ERROR" "  $CROSS_MARK $1"
}

warn_msg() {
    gum style --foreground "$WARNING" "  $INFO_SYMBOL $1"
}

info_msg() {
    gum style --foreground "$INFO" "  $INFO_SYMBOL $1"
}

dim_msg() {
    gum style --foreground "$DIM" "    $1"
}

# ### Interactive Elements
# run_with_spinner() {
#     local message="$1"
#     local use_sudo=${2:-false}
#     local command="${@:3}"
    

#     local sudo_prefix=""
#     [ "$use_sudo" = true ] && sudo_prefix="sudo"

#     echo "$message"
#     echo "$command"
#     echo "$use_sudo"
#     echo "$sudo_prefix"

#     gum spin --spinner dot --title "$(gum style --foreground "$PRIMARY" "$message")" -- $sudo_prefix bash -c "$command"
# }

run_with_spinner() {
    local message="$1"
    local use_sudo=${2:-false}
    shift 2  # Remove first two arguments, leaving only the command
    
    local sudo_prefix=""
    [ "$use_sudo" = true ] && sudo_prefix="sudo"
    
    gum spin --spinner dot --title "$(gum style --foreground "$PRIMARY" "$message")" -- $sudo_prefix bash -c "$*"
} 

confirm_action() { 
    local message="$1"
    gum confirm "$(gum style --foreground "$WARNING" "$message")" && return 0 || return 1
}

