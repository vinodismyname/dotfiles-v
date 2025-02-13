#!/usr/bin/env bash
# scripts/install_linux.sh - Additional Linux-specific setup for Dotfiles
set -euo pipefail

DRY_RUN="${1:-false}"

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

echo

info_msg "Updating Yum Package Manager..."
if command -v yum &>/dev/null; then
  run_with_spinner "yum update..." false "sleep 1"
  if [ "$DRY_RUN" = false ]; then
    sudo yum update -y &>/dev/null
  else
    warn_msg "[DRY_RUN] sudo yum update -y"
  fi
  success_msg "yum updated"
else
  warn_msg "yum not found; skipping system update."
fi

echo

info_msg "Installing essential packages via yum..."
PACKAGES=(lshw pciutils)
for pkg in "${PACKAGES[@]}"; do
  if [ "$DRY_RUN" = false ]; then
    if command -v yum &>/dev/null; then
      sudo yum install -y "$pkg" &>/dev/null
    fi
  else
    warn_msg "[DRY_RUN] Would install $pkg"
  fi
done

success_msg "Finished installing Linux prerequisites"
