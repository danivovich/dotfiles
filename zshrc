# Where Am I?
platform='unknown'
unamestr=`uname`
hoststr=`hostname`
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

plugins=(git code_cd)

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



#------------------------------
# Local settings
#------------------------------

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

