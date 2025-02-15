#!/usr/bin/env bash
#
# amazon/amazon_setup.sh - Amazon-specific environment setup
#
set -euo pipefail
source "$( dirname "${BASH_SOURCE[0]}" )/../scripts/ui_components.sh"
WORKPLACE_DIR="/workplace/${USER}"


# ─────────────────────────────────────────────────────────────────────────────
# Toolbox
# ─────────────────────────────────────────────────────────────────────────────
info_msg "Initializing Toolbox..."

# 1. Ensure Toolbox
if ! command -v toolbox &>/dev/null; then
  run_with_spinner "Toolbox not found. Attempting to install..." false "sudo yum install -y toolbox"
  if [ $? -eq 0 ]; then
    success_msg "Toolbox installed."
    export PATH="$PATH:$(dirname $(which toolbox))/bin"
  else
    error_msg "Could not install Toolbox. Exiting Amazon setup."
    exit 1
  fi
else
  export PATH="$PATH:$(dirname $(which toolbox))/bin"
  success_msg "Toolbox is already installed."
fi

run_with_spinner "Updating Toolbox..." false "toolbox update"
if [ $? -eq 0 ]; then
  success_msg "Toolbox Updated."
else
  warn_msg "Could not update Toolbox. Proceeding anyways.."
fi


run_with_spinner "Installing Brazil packages..." false "toolbox install eda axe"
if [ $? -eq 0 ]; then
  success_msg "Toolbox packages installed."
else
  warn_msg "Could not install toolbox packages. Continuing anyway..."
fi


echo
# ─────────────────────────────────────────────────────────────────────────────
# Brazil / Builder-Tools
# ─────────────────────────────────────────────────────────────────────────────
info_msg "Setting up Brazil / builder-tools..."

# unlinking brew pkg-config for mise to work
run_with_spinner "Unlinking Brew pkg-config temporarily to avoid conflict with Builder-tool installs" false "brew unlink pkg-config"

# Run axe init in the background or in a subshell
run_with_spinner "Initializing builder-tools with AxE..." false "yes | $HOME/.toolbox/bin/axe init builder-tools &>/dev/null"
if [ $? -eq 0 ]; then
  success_msg "builder-tools initialized."
else
  warn_msg "Could not initialize builder-tools. Continuing anyway..."bash
fi

if command -v  "$HOME"/.toolbox/bin/brazil &>/dev/null; then
  run_with_spinner "Setting up Brazil completions..." false "  $HOME/.toolbox/bin/brazil setup completion || true"
  success_msg "brazil completions initialized."
else
  dim_msg "brazil command not found. Skipping Brazil completion setup."
fi

# relinking brew pkg-config after install
run_with_spinner "Relinking Brew pkg-config" false "brew link pkg-config"

echo

# ─────────────────────────────────────────────────────────────────────────────
# Workspace Setup
# ─────────────────────────────────────────────────────────────────────────────

# 3. Create /workplace/${USER}

info_msg "Verifying and Setting up Workplace Folder"
run_with_spinner "Setting up workplace directory..." false \
 "sudo mkdir -p -m 755 \"${WORKPLACE_DIR}\" && sudo chown -R \"${USER}:amazon\" \"${WORKPLACE_DIR}\" "


if [ ! -d "${HOME}/workplace" ]; then
  ln -s "${WORKPLACE_DIR}" "${HOME}/workplace"
  success_msg "Created symlink: ~/workplace -> ${WORKPLACE_DIR}"
else
  warn_msg "Already Exists -> ${WORKPLACE_DIR}"
fi

echo

success_msg "Amazon environment setup complete!"
