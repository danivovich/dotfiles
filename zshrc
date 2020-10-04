autoload -Uz compinit
compinit

if [[ -r "$HOME/.powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source ~/.powerlevel10k/powerlevel10k.zsh-theme
else
  echo "PowerLevel 10k not installed. https://github.com/romkatv/powerlevel10k#manual"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Where Am I?
platform='unknown'
unamestr=`uname`
hoststr=`hostname`
me=`whoami`

# old zsh plugins: bundler, git, rails

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
export HISTCONTROL=ignorespace:ignoredups
# F@CK Spring
export DISABLE_SPRING=1

#------------------------------
# Aliases
#------------------------------

alias tmux="TERM=screen-256color-bce tmux -u -S /tmp/tmux-sock-$me"

alias millis='python -c "import time; print(int(time.time()*1000))"'

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

c() { cd ~/Code/$1; }

_c() { _files -W ~/Code -/; }
compdef _c c

_marked_tab() { _files -g "*.md *.markdown"; }
compdef _marked_tab mark

`which thefuck > /dev/null`
if [[ $? == 0 ]]; then
  eval $(thefuck --alias)
fi

#------------------------------
# Local settings
#------------------------------

if [[ -r "$HOME/.asdf/asdf.sh" ]]; then
 source $HOME/.asdf/asdf.sh
 fpath=(${ASDF_DIR}/completions $fpath)
 autoload -Uz compinit && compinit
fi

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

if [[ -r "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
