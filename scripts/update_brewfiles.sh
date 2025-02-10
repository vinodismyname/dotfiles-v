#!/usr/bin/env bash
#
# scripts/update_brewfiles.sh - Regenerate Brewfiles from current system
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILES_DIR="${DOTFILES_DIR}/Brewfiles"

COMMON_BREWFILE="${BREWFILES_DIR}/Brewfile.common"
MAC_BREWFILE="${BREWFILES_DIR}/mac.Brewfile"
LINUX_BREWFILE="${BREWFILES_DIR}/linux.Brewfile"

PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"

case "$PLATFORM" in
  darwin)
    brew bundle dump --force --file="$MAC_BREWFILE"
    echo "Updated $MAC_BREWFILE with currently installed packages."
    ;;
  linux)
    brew bundle dump --force --file="$LINUX_BREWFILE"
    echo "Updated $LINUX_BREWFILE with currently installed packages."
    ;;
  *)
    echo "Unknown or unsupported platform for updating Brewfiles."
    ;;
esac