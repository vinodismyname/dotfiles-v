alias ls='eza -1 --color=always --group-directories-first --icons=always'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lS='eza --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"

# Git
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gco="git checkout"
alias gs="git status"
alias gl="git pull --rebase"
alias gd="git diff"
alias gco='git checkout $(git branch | fzf)'
alias glog='git log --oneline --decorate --graph --all'

# Docker
alias d="docker"
alias dps="docker ps"
alias di="docker images"
alias dc='docker-compose'
function dkill() {
  local containers=$(docker ps -q)
  [[ -z $containers ]] && echo "No containers to kill" && return
  docker kill $containers
}



alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
alias reload-zsh="source ~/.zshrc"
alias finch='sudo finch'

if [ "$IS_AMZN" = true ]; then 
  alias bb='brazil-build'
  alias bba='brazil-build apollo-pkg'
  alias bre='brazil-runtime-exec'
  alias brc='brazil-recursive-cmd'
  alias bws='brazil ws'
  alias bwsuse='bws use -p'
  alias bwscreate='bws create -n'
  alias bbr='brc brazil-build'
  alias bball='brc --allPackages'
  alias bbb='brc --allPackages brazil-build'
  alias bbra='bbr apollo-pkg'


  if [ "$IS_LINUX" = true ]; then 
    alias aws='/apollo/env/AwsCli/bin/aws'
    if [ "$HAS_NVIDIA" = true ]; then 
      alias nvitop="uvx nvitop --colorful"
    fi
  fi


  if [ "$IS_MAC" = true ]; then
    alias code="open -a Visual\ Studio\ Code.app"
    alias finder="open ."
    alias hide-desktop='defaults write com.apple.finder CreateDesktop false; killall Finder'
    alias show-desktop='defaults write com.apple.finder CreateDesktop true; killall Finder'
    alias edit-zsh="code ~/.zshrc"
    alias c="pbcopy"
    alias v="pbpaste"
  fi

fi