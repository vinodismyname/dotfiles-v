#!/usr/bin/env bash
#
# scripts/install_linux.sh - Additional Linux-specific setup
#

set -euo pipefail

DRY_RUN="${1:-false}"

if command -v yum &>/dev/null; then
  gum spin --title "Updating yum..." -- sleep 1
  [ "$DRY_RUN" = false ] && sudo yum update -y || \
    gum style --foreground 3 "[DRY_RUN] sudo yum update -y"
fi

# Install some common Linux packages from your distro
PACKAGES=(lshw)
for pkg in "${PACKAGES[@]}"; do
  if [ "$DRY_RUN" = false ]; then
    if command -v yum &>/dev/null; then
      sudo yum install -y "$pkg"
    fi
  else
    gum style --foreground 3 "[DRY_RUN] installing $pkg"
  fi
done
