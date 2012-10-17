# Where Am I?
platform='unknown'
unamestr=`uname`
hoststr=`hostname`
me=`whoami`
if [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  export ZSH_THEME="robbyrussell" # tell which system I'm on with a different theme

  if [[ "$hoststr" == 'rohn.local' ]]; then
    export ZSH_THEME="arrow" # tell which system I'm on with a different theme
  fi

elif [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  export ZSH_THEME="cloud" # tell which system I'm on with a different theme
fi

plugins=(git code_cd marked_tab)

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
source $ZSH/oh-my-zsh.sh

# Customize to your needs...

#------------------------------
# Settings
#------------------------------

zstyle ":completion:*:commands" rehash 1

#------------------------------
# Variables
#------------------------------
if [[ "$unamestr" == 'Darwin' ]]; then
  export EDITOR="vim"
  alias vim='mvim -v'
elif [[ "$unamestr" == 'Linux' ]]; then
  export EDITOR="vim"
fi

export PAGER="less"

#------------------------------
# Aliases
#------------------------------

alias tmux="TERM=screen-256color-bce tmux -u -S /tmp/tmux-sock-$me"

#------------------------------
# Functions
#------------------------------

tmux_attach_or_create () {
  if (($# == 1)); then
    tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
  else
    echo "Must provide a session name"
  fi
}

t ()
{
  if (($# == 1)); then
    tmux_attach_or_create $1
  else
    tmux_attach_or_create $(basename $(pwd))
  fi
}

_t() {
  local line
  local -a sessions
  tmux ls | cut -d : -f 1 | while read -A line; do sessions=($line $sessions) done
  _values $sessions && ret=0
}
compdef _t t

#------------------------------
# Local settings
#------------------------------

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
