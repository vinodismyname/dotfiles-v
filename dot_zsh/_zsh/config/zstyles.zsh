# # ~/.zshrc
function cd-complete() {
  if [[ $LBUFFER == "cd" ]]; then
    LBUFFER="z "
    zle end-of-line
    zle expand-or-complete
  else
    zle expand-or-complete
  fi
}
zle -N cd-complete
bindkey "^I" cd-complete


zstyle ':completion:*' list-separator ''
zstyle ':completion:*' matcher-list 'm:{[:upper:][:lower:]-_}={[:lower:][:upper:]_-}'
zstyle ':completion:*' word true
zstyle ':completion::complete:*' use-cache true
zstyle ':completion::complete:*' call-command true
zstyle ':completion:*:processes' command "ps -wu$USER -opid,user,comm"
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:coredumpctl:*' sort false
zstyle ':completion:*' option-stacking true
zstyle ':completion:*' extra-verbose true
zstyle ':completion:*' sort false
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors "echo $LS_COLORS | tr ':' ' '"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' format '%d'