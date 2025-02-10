#!/usr/bin/env bash
#
# scripts/install_mac.sh - Additional macOS-specific setup
#
# Usage: source scripts/install_mac.sh [DRY_RUN]
set -euo pipefail

DRY_RUN="${1:-false}"

PRIMARY=12
SUCCESS=10
HEADER=13
WARNING=214
DIM=8

divider() {
  gum style --foreground "$DIM" -- "--------------------------------------------------------------------------------"
}

gum style --foreground "$HEADER" --bold "====> macOS-specific Setup"

divider

if gum confirm "Perform macOS software update? (Requires sudo)"; then
  if [ "$DRY_RUN" = false ]; then
    sudo softwareupdate -i -a
  else
    gum style --foreground "$WARNING" "[DRY_RUN] Would run: sudo softwareupdate -i -a"
  fi
fi

gum style --foreground "$SUCCESS" "Done with macOS-specific steps!"
