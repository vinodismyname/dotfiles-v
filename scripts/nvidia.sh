#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# scripts/nvidia.sh
# Basic script to install NVIDIA drivers + CUDA on Linux
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

subheading "Installing NVIDIA driver and CUDA..."

DRIVER_VERSION="535.161.08"
DRIVER_FILE="NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"
DRIVER_URL="https://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VERSION}/${DRIVER_FILE}"

if [ ! -f "$DRIVER_FILE" ]; then
  run_with_spinner "Downloading NVIDIA driver..." \
    'curl -LO "$DRIVER_URL"'
fi

chmod +x "$DRIVER_FILE"
sudo ./"$DRIVER_FILE" --no-questions --ui=none

echo

CUDA_INSTALLER="cuda_12.2.2_535.104.05_linux.run"
CUDA_URL="https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/${CUDA_INSTALLER}"

if [ ! -f "$CUDA_INSTALLER" ]; then
  run_with_spinner "Downloading CUDA..." -- \
    'curl -LO "${CUDA_URL}"'
fi

chmod +x "$CUDA_INSTALLER"
sudo ./"$CUDA_INSTALLER" --silent --toolkit

echo

success_msg "✓ NVIDIA driver + CUDA installation complete!"
