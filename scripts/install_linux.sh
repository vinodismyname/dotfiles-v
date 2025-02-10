#!/usr/bin/env bash
#
# scripts/install_linux.sh - Additional Linux-specific setup
#
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

gum style --foreground "$HEADER" --bold "====> Linux-specific Setup"

divider

gum style --foreground "$PRIMARY" --bold "Updating Yum Package Manager..."
if command -v yum &>/dev/null; then
  gum spin --spinner line --title "yum update..." -- sleep 1
  if [ "$DRY_RUN" = false ]; then
    sudo yum update -y &>/dev/null
  else
    gum style --foreground "$WARNING" "[DRY_RUN] sudo yum update -y"
  fi
  gum style --foreground "$SUCCESS" "✓ yum updated"
fi

divider

gum style --foreground "$PRIMARY" --bold "Installing Yum Default Packages..."
PACKAGES=(lshw)
for pkg in "${PACKAGES[@]}"; do
  if [ "$DRY_RUN" = false ]; then
    if command -v yum &>/dev/null; then
      sudo yum install -y "$pkg" &>/dev/null
    fi
  else
    gum style --foreground "$WARNING" "[DRY_RUN] installing $pkg"
  fi
done

gum style --foreground "$SUCCESS" --bold "Installed Yum Packages"
