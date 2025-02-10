#!/usr/bin/env zsh

_aws_profile_switcher() {
  # Check if config file exists
  if [[ ! -f ~/.aws/config ]]; then
    echo "AWS config file not found at ~/.aws/config"
    return 1
  fi

  # Grab profile names
  # Alternatively, on newer AWS CLI versions, you could do:
  # profiles=$(aws configure list-profiles 2>/dev/null)
  local profiles
  profiles=$(
    command grep -E '^\[profile' ~/.aws/config \
    | command sed -E 's/\[profile (.+)\]/\1/'
  )

  if [[ -z "$profiles" ]]; then
    echo "No AWS profiles found in ~/.aws/config"
    return 1
  fi

  local num_profiles height selected_profile
  num_profiles=$(echo "$profiles" | wc -l | tr -d ' ')
  height=$(( num_profiles < 10 ? num_profiles : 10 ))

  # Ensure fzf is installed before proceeding
  if ! command -v fzf &>/dev/null; then
    echo "fzf not found. Please install fzf first."
    return 1
  fi

  # Use fzf to select a profile. The --preview now includes account number, ARN, region, etc.
  selected_profile=$(
    echo "$profiles" \
    | fzf \
        --prompt="Select AWS Profile: " \
        --height="${height}0%" \
        --layout=reverse \
        --border=rounded \
        --preview='
          # Display Account Number
          echo "Account Number: $(aws sts get-caller-identity --profile {} --query Account --output text 2>/dev/null || echo "N/A")"

          # Display ARN
          echo "User ARN:      $(aws sts get-caller-identity --profile {} --query Arn --output text 2>/dev/null || echo "N/A")"

          # Display the configured region
          echo "Region:        $(aws configure get region --profile {} 2>/dev/null || echo "N/A")"

          echo ""
          # Show basic aws configure info
          aws configure list --profile {} 2>/dev/null
        ' \
        --preview-window=right:45%:wrap
  )

  # Export selected profile if not empty
  if [[ -n "$selected_profile" ]]; then
    export AWS_PROFILE="$selected_profile"
    echo "AWS_PROFILE set to: $selected_profile"

    # If powerlevel10k is loaded, update prompt
    if typeset -f prompt_powerlevel10k_setup &>/dev/null; then
      p10k reload
    fi
  fi
}

# --- Minimal lazy-load wrapper ---
function awsp() {
  # Remove this placeholder so we only parse once
  unfunction awsp

  # Any future calls to `awsp` should go directly to `_aws_profile_switcher`
  alias awsp="_aws_profile_switcher"

  # Invoke `_aws_profile_switcher` now for this first call
  _aws_profile_switcher "$@"
}
