{
  setopt localoptions extendedglob
  autoload -Uz zrecompile

  zsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  zcompdump="$zsh_cache/zcompdump"

  zrecompile -p \
    -R ~/.zshrc -- \
    -R ~/.zshenv -- \
    -M "$zcompdump"
} &> /dev/null &!