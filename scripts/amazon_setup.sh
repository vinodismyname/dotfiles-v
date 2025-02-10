#!/usr/bin/env bash
#
# amazon/amazon_setup.sh - Amazon-specific environment setup
#
set -euo pipefail

PRIMARY=12
SUCCESS=10
HEADER=13
WARNING=214
ERROR=196
DIM=8

divider() {
  gum style --foreground "$DIM" -- "--------------------------------------------------------------------------------"
}

gum style --foreground "$HEADER" --bold "====> Running Amazon environment setup..."


# 1. Ensure Toolbox
if ! command -v toolbox &>/dev/null; then
  gum style --foreground "$DIM" "Toolbox not found. Attempting to install..."
  if sudo yum install -y toolbox &>/dev/null; then
    gum style --foreground "$SUCCESS" "✓ Toolbox installed."
  else
    gum style --foreground "$ERROR" "× Could not install Toolbox. Exiting Amazon setup."
    exit 1
  fi
else
  gum style --foreground "$SUCCESS" "✓ Toolbox is already installed."
fi

divider

gum style --foreground "$DIM" "Updating Toolbox..."
toolbox update &>/dev/null

divider

# 2. Brazil / builder-tools via toolbox
gum style --foreground "$PRIMARY" --bold "Attempting to install Brazil / builder-tools..."
if toolbox install eda axe &>/dev/null; then
  gum style --foreground "$SUCCESS" "✓ Toolbox packages installed."
else
  gum style --foreground "$WARNING" "Could not install toolbox packages. Continuing anyway..."
fi

# Run axe init in the background or in a subshell
if yes | axe init builder-tools &>/dev/null; then
  gum style --foreground "$SUCCESS" "✓ builder-tools initialized."
else
  gum style --foreground "$WARNING" "Could not initialize builder-tools. Continuing anyway..."
fi

divider

if command -v brazil &>/dev/null; then
  brazil setup completion &>/dev/null || true
else
  gum style --foreground "$DIM" "brazil command not found. Skipping Brazil completion setup."
fi

divider

# 3. Create /workplace/${USER}
WORKPLACE_DIR="/workplace/${USER}"
sudo mkdir -p -m 755 "$WORKPLACE_DIR"
sudo chown -R "${USER}:amazon" "$WORKPLACE_DIR"

gum style --foreground "$PRIMARY" --bold "Verifying and Setting up Workplace Folder"
if [ ! -d "$HOME/workplace" ]; then
  ln -s "$WORKPLACE_DIR" "$HOME/workplace"
  gum style --foreground "$SUCCESS" "✓ Created symlink: ~/workplace -> $WORKPLACE_DIR"
fi

divider
gum style --foreground "$SUCCESS" --bold "Amazon environment setup complete!"
