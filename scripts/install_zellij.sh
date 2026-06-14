#!/usr/bin/env bash
# scripts/install_zellij.sh - Install Zellij Multiplexer
set -euo pipefail

source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"

arch=$(uname -m)

info_msg "Installing Zellij"

if [ "$(uname -s)" != "Darwin" ]; then
  error_msg "This Zellij installer is macOS-only."
  exit 1
fi

filename="zellij-${arch}-apple-darwin.tar.gz"
url="https://github.com/zellij-org/zellij/releases/latest/download/${filename}"
run_with_spinner "Downloading Zellij binary for macOS..." false "curl -LO \"$url\" "

info_msg "Uncompressing Zellij binary..."
tar -xf "./${filename}" &>/dev/null

info_msg "Moving Zellij binary to /bin directory..."
sudo mv "./zellij" /bin/zellij
rm "./${filename}"

if [ -f "/bin/zellij" ]; then
  success_msg "Zellij binary installed successfully!"
else
  error_msg "Zellij binary not installed successfully!"
fi
