# Where Am I?
platform='unknown'
unamestr=`uname`
hoststr=`hostname`
me=`whoami`

if [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  export ZSH_THEME="robbyrussell"
elif [[ "$hoststr" == 'galena' ]]; then
  platform='linux'
  export ZSH_THEME="risto"
elif [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  export ZSH_THEME="cloud"
fi

plugins=(bundler git rails code_cd marked_tab)

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

alias millis='python -c "import time; print(int(time.time()*1000))"'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
source $ZSH/oh-my-zsh.sh

# Customize to your needs...

#------------------------------
# Settings
#------------------------------

zstyle ":completion:*:commands" rehash 1

`which keychain > /dev/null`
if [[ $? == 0 ]]; then
  eval `keychain --eval --agents ssh --inherit any --quiet --quick`
  function add_all_ssh_keys()
  {
    ssh-add $(grep -l PRIVATE ~/.ssh)
  }
  alias ssh="(ssh-add -l > /dev/null || add_all_ssh_keys ) && ssh"
else
  echo "Keychain not installed"
fi

#------------------------------
# Variables
#------------------------------

export EDITOR="vim"
export PAGER="less"
# F@CK Spring
export DISABLE_SPRING=1

#------------------------------
# Aliases
#------------------------------

alias tmux="TERM=screen-256color-bce tmux -u -S /tmp/tmux-sock-$me"

if [[ "$unamestr" == 'Darwin' ]]; then
  export EDITOR="vim"
  alias vim='mvim -v'
  alias view='mvim -v'
fi

alias iexs='iex -S mix'
alias bundle='nocorrect bundle'
alias fs='foreman start'

#------------------------------
# Functions
#------------------------------

tls ()
{
  tmux ls
}

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

if [[ -r "$HOME/.asdf/asdf.sh" ]]; then
 source $HOME/.asdf/asdf.sh
 source $HOME/.asdf/completions/asdf.bash
fi

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

if [[ -r "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi
