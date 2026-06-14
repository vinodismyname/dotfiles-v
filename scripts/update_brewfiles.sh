#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# scripts/update_brewfiles.sh - Regenerate Brewfiles from current system
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAC_BREWFILE="${DOTFILES_DIR}/dependencies/mac.Brewfile"

subheading "Updating macOS Brewfile from current system"

divider

if [ "$(uname -s)" != "Darwin" ]; then
  error_msg "This helper is macOS-only."
  exit 1
fi

run_with_spinner "Dumping Brewfile..." false \
  "brew bundle dump --force --file=\"$MAC_BREWFILE\""
success_msg "Updated $MAC_BREWFILE with currently installed packages."
