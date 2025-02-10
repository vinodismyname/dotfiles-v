#!/usr/bin/env bash
# scripts/nvidia.sh
# Basic script to install NVIDIA drivers + CUDA on Linux

set -euo pipefail

echo "Installing NVIDIA driver and CUDA..."

DRIVER_VERSION="535.161.08"
DRIVER_FILE="NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"
DRIVER_URL="https://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VERSION}/${DRIVER_FILE}"

if [ ! -f "$DRIVER_FILE" ]; then
  curl -LO "$DRIVER_URL"
fi
chmod +x "$DRIVER_FILE"
sudo ./"$DRIVER_FILE" --no-questions --ui=none

CUDA_INSTALLER="cuda_12.2.2_535.104.05_linux.run"
CUDA_URL="https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/${CUDA_INSTALLER}"

if [ ! -f "$CUDA_INSTALLER" ]; then
  curl -LO "$CUDA_URL"
fi
chmod +x "$CUDA_INSTALLER"
sudo ./"$CUDA_INSTALLER" --silent --toolkit

# Update environment
grep -qxF 'export PATH=/usr/local/cuda-12.2/bin:$PATH' ~/.zshrc || \
  echo 'export PATH=/usr/local/cuda-12.2/bin:$PATH' >> ~/.zshrc
grep -qxF 'export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH' ~/.zshrc || \
  echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH' >> ~/.zshrc

echo "NVIDIA driver + CUDA installation complete!"
