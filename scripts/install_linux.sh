#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# scripts/install_linux.sh - Additional Linux-specific setup
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

DRY_RUN="${1:-false}"

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

heading "====> Linux-specific Setup"

divider

primary_msg --bold "Updating Yum Package Manager..."
if command -v yum &>/dev/null; then
  gum spin --spinner line --title "yum update..." -- sleep 1
  if [ "$DRY_RUN" = false ]; then
    sudo yum update -y &>/dev/null
  else
    warn_msg "[DRY_RUN] sudo yum update -y"
  fi
  success_msg "✓ yum updated"
fi

divider

primary_msg --bold "Installing Yum Default Packages..."
PACKAGES=(lshw)
for pkg in "${PACKAGES[@]}"; do
  if [ "$DRY_RUN" = false ]; then
    if command -v yum &>/dev/null; then
      sudo yum install -y "$pkg" &>/dev/null
    fi
  else
    warn_msg "[DRY_RUN] installing $pkg"
  fi
done

success_msg --bold "Installed Yum Packages"
