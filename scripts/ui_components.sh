#!/usr/bin/env bash

### Colors for Gum styling (ANSI 256 color codes)
PRIMARY=12    # A bright/cyan-like color for major headings
SUCCESS=10    # Bright green for success
HEADER=13     # Bright Purple for Headers
WARNING=214   # Orange-ish for warnings
ERROR=196     # Bright red for errors
DIM=8         # Subtle/dim grey

### A simple divider function for consistent separators
divider() {
  gum style --foreground "$DIM" -- "--------------------------------------------------------------------------------"
}

### A heading function for major steps
heading() {
gum style --foreground "$DIM" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
gum style --bold --foreground "$HEADER"  "==> $1"
gum style --foreground "$DIM" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

### Primary Messages
primary_msg() {
    gum style --foreground "$PRIMARY" --bold  "$1"
}

### A success message function
success_msg() {
  gum style --foreground "$SUCCESS" "✓ $1"
}

### An error message function
error_msg() {
  gum style --foreground "$ERROR" "× $1"
}

### A warning message function
warn_msg() {
  gum style --foreground "$WARNING" "⚠ $1"
}

### Dim Message
dim_msg() {
gum style --foreground "$DIM" "$1"
}

run_with_spinner() {
    local title=$1
    local cmd=$2
    gum spin --spinner dot --title "${title}..." -- eval "${cmd}"
}
