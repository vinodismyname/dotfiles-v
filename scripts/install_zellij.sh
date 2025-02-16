#!/usr/bin/env bash
# scripts/install_zellij.sh - Install Zellij Multiplexer
set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

# Get the architecture of the machine
arch=$(uname -m)
os=$(uname -s)


info_msg "Installing Zellij"

# Download the Zellij binary
if [ "$os" == "Darwin" ]; then
  filename="zellij-${arch}-apple-darwin.tar.gz"
  url="https://github.com/zellij-org/zellij/releases/latest/download/${filename}"
  run_with_spinner "Downloading Zellij binary for macOS..." false "curl -LO \"$url\" "
else
  if [ "$os" == "Linux" ]; then
    filename="zellij-${arch}-unknown-linux-musl.tar.gz"
    url="https://github.com/zellij-org/zellij/releases/latest/download/${filename}"
    run_with_spinner "Downloading Zellij binary for Linux..." false "curl -LO \"$url\" "
  else
    echo "Unsupported OS: $os"
  fi
fi

# Uncompress the Zellij binary
info_msg "Uncompressing Zellij binary..."
tar -xf "./${filename}" &>/dev/null

# Move the Zellij binary to the /bin directory
info_msg "Moving Zellij binary to /bin directory..."
sudo mv "./zellij" /bin/zellij
rm "./${filename}"

# Check if the Zellij binary exists
if [ -f "/bin/zellij" ]; then
  success_msg "Zellij binary installed successfully!"
else
  error_msg "Zellij binary not installed successfully!"
fi