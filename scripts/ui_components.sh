#!/usr/bin/env bash


### Color Palette (ANSI 256 color codes)
PRIMARY=39      # Bright blue
SUCCESS=82      # Bright green
WARNING=178     # Light orange
ERROR=196       # Bright red
INFO=75         # Sky blue
DIM=240         # Elegant gray

### Unicode Characters
CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW_RIGHT="→"
INFO_SYMBOL="•"

### Styling Functions
heading() {
    echo
    gum style --foreground "$PRIMARY" --bold "$ARROW_RIGHT $1"
    gum style --foreground "$DIM" "$(printf '━%.0s' $(seq 1 50))"
}

subheading() {
    echo
    gum style --foreground "$PRIMARY" "  $INFO_SYMBOL $1"
    gum style --foreground "$DIM" "  $(printf '─%.0s' $(seq 1 40))"
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

### Interactive Elements
run_with_spinner() {
    local message="$1"
    local command="${@:2}"
    gum spin --spinner dot --title "$(gum style --foreground "$PRIMARY" "$message")" -- bash -c "$command"
}

confirm_action() {
    local message="$1"
    gum confirm "$(gum style --foreground "$WARNING" "$message")" && return 0 || return 1
}
