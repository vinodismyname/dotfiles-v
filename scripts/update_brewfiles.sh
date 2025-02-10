#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# scripts/update_brewfiles.sh - Regenerate Brewfiles from current system
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILES_DIR="${DOTFILES_DIR}/Brewfiles"
COMMON_BREWFILE="${BREWFILES_DIR}/Brewfile.common"
MAC_BREWFILE="${BREWFILES_DIR}/mac.Brewfile"
LINUX_BREWFILE="${BREWFILES_DIR}/linux.Brewfile"
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"

heading "====> Updating Brewfiles from current system"

divider

case "$PLATFORM" in
  darwin)
    gum spin --spinner line --title "Dumping Brewfile (mac)..." -- \
      brew bundle dump --force --file="$MAC_BREWFILE"
    success_msg "✓ Updated $MAC_BREWFILE with currently installed packages."
    ;;
  linux)
    gum spin --spinner line --title "Dumping Brewfile (linux)..." -- \
      brew bundle dump --force --file="$LINUX_BREWFILE"
    success_msg "✓ Updated $LINUX_BREWFILE with currently installed packages."
    ;;
  *)
    warn_msg "Unknown or unsupported platform for updating Brewfiles."
    ;;
esac
