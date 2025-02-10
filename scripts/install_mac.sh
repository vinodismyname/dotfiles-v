#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
# scripts/install_mac.sh - Additional macOS-specific setup
#
# Usage: source scripts/install_mac.sh [DRY_RUN]
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

DRY_RUN="${1:-false}"

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

heading "====> macOS-specific Setup"

divider

if gum confirm "Perform macOS software update? (Requires sudo)"; then
  if [ "$DRY_RUN" = false ]; then
    sudo softwareupdate -i -a
  else
    warn_msg "[DRY_RUN] Would run: sudo softwareupdate -i -a"
  fi
fi

success_msg "Done with macOS-specific steps!"
