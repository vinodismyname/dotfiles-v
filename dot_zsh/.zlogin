{
  setopt localoptions extendedglob
  autoload -Uz zrecompile

  zrecompile -p \
    -R ~/.zshrc -- \
    -R ~/.zshenv -- \
    -M ~/.zcompdump
} &> /dev/null &!