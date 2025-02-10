#!/usr/bin/env bash
#
# amazon/amazon_setup.sh - Amazon-specific environment setup

set -euo pipefail

echo "Running Amazon environment setup..."

# 1. Ensure Toolbox
if ! command -v toolbox &>/dev/null; then
  echo "Toolbox not found. Attempting to install..."
  sudo yum install -y toolbox || {
    echo "ERROR: Could not install toolbox. Exiting Amazon setup."
    exit 1
  }
fi
echo "Toolbox is installed."

# 2. Brazil / builder-tools via toolbox
echo "Attempting to install Brazil / builder-tools..."
toolbox install eda axe
axe init builder-tools

if command -v brazil &>/dev/null; then
  brazil setup completion || true
else
  echo "brazil command not found. Skipping Brazil completion setup."
fi

# 3. Create /workplace/${USER}
WORKPLACE_DIR="/workplace/${USER}"
sudo mkdir -p -m 755 "$WORKPLACE_DIR"
sudo chown -R "${USER}:amazon" "$WORKPLACE_DIR"

if [ ! -d "$HOME/workplace" ]; then
  ln -s "$WORKPLACE_DIR" "$HOME/workplace"
  echo "Created symlink: ~/workplace -> $WORKPLACE_DIR"
fi

echo "Amazon environment setup complete!"
