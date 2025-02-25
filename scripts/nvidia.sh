#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# scripts/nvidia.sh
# Basic script to install NVIDIA drivers + CUDA on Linux
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

subheading "Installing Nvidia driver and CUDA..."

info_msg "Nvidia Driver Setup"
DRIVER_VERSION="570.86.15"
DRIVER_FILE="NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"
DRIVER_URL="https://us.download.nvidia.com/tesla/${DRIVER_VERSION}/${DRIVER_FILE}"

if [ ! -f "$DRIVER_FILE" ]; then
  run_with_spinner "Downloading NVIDIA driver..." true "curl -LO $DRIVER_URL"
  chmod +x "./${DRIVER_FILE}"
fi
run_with_spinner "Installing NVIDIA driver..." true "(yes 1 ; yes) | CC=/usr/bin/gcc10-cc sh ./${DRIVER_FILE} --ui=none"
echo

info_msg "CUDA Setup"
CUDA_INSTALLER="cuda_12.8.0_570.86.10_linux.run"
CUDA_URL="https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/${CUDA_INSTALLER}"
run_with_spinner "Downloading CUDA..." true "curl -LO \"${CUDA_URL}\""
chmod +x "./${CUDA_INSTALLER}"
run_with_spinner "installing CUDA" true "(yes 1 ; yes) | CC=/usr/bin/gcc10-cc sh ./${CUDA_INSTALLER} --toolkit --silent"
success_msg "CUDA Setup complete"

# echo
info_msg "Setting up Nvidia Container Toolkit"
sudo yum-config-manager --add-repo https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo  &>/dev/null
run_with_spinner "Disabling graphics temporarily" true "sudo yum-config-manager --disable amzn2-graphics &>/dev/null"
run_with_spinner "Removing any existing nvidia-instances" true "sudo yum erase -y libnvidia-container &>/dev/null"
run_with_spinner "Installing latest nvidia-container-toolkit" true  "sudo yum install -y nvidia-container-toolkit &>/dev/null"
run_with_spinner "Enabling graphics again" true "sudo yum-config-manager --enable amzn2-graphics &>/dev/null"
run_with_spinner "Enabling graphics again" true "sudo yum-config-manager --enable amzn2-graphics &>/dev/null"
run_with_spinner "Installing Docker runtime" true "sudo yum install -y docker-runtime-nvidia &>/dev/null"
run_with_spinner "Configuring Container runtime" true "sudo nvidia-ctk runtime configure --runtime=docker &>/dev/null"
run_with_spinner "Restarting Docker Daemon" true "sudo systemctl restart docker &>/dev/null"
success_msg "Nvidia Container Toolkit installed"

success_msg "Nvidia setup complete!"
