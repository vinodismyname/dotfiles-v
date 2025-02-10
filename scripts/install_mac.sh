#!/usr/bin/env bash
#
# scripts/install_mac.sh - Additional macOS-specific setup
#
# Usage: source scripts/install_mac.sh [DRY_RUN]

set -euo pipefail

DRY_RUN="${1:-false}"

# Example: macOS system updates or extra steps
if gum confirm "Perform macOS software update? (Requires sudo)"; then
  if [ "$DRY_RUN" = false ]; then
    sudo softwareupdate -i -a
  else
    gum style --foreground 3 "[DRY_RUN] Would run: sudo softwareupdate -i -a"
  fi
fi

# More specialized macOS-only tasks can live here
