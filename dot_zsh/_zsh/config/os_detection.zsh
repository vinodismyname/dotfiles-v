export OS_NAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
export IS_MAC=false
export IS_LINUX=false
export HAS_NVIDIA=false
export IS_AMZN=false

if [[ "$OS_NAME" == "darwin" ]]; then
  IS_MAC=true
elif [[ "$OS_NAME" == "linux" ]]; then
  IS_LINUX=true
else
  echo "Unsupported OS: $OS_NAME"
  exit 1
fi


if [ "$IS_LINUX" = true ];
  then 
    if sudo lshw | grep -i nvidia &>/dev/null; 
    then HAS_NVIDIA=true
    fi
fi

if command -v mwinit &>/dev/null; 
    then IS_AMZN=true
fi
