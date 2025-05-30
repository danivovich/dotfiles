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

fpath=($HOME/.dotfiles/zsh-plugins-compdef $fpath)
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

source $HOME/.dotfiles/zsh-plugins/bundler.plugin.zsh
source $HOME/.dotfiles/zsh-plugins/git.plugin.zsh
source $HOME/.dotfiles/zsh-plugins/rails.plugin.zsh
source $HOME/.dotfiles/zsh-plugins/key-bindings.zsh

zstyle ":completion:*:commands" rehash 1


`which /opt/homebrew/bin/brew > /dev/null`
if [[ $? == 0 ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

`which keychain > /dev/null`
if [[ $? == 0 ]]; then
  eval `keychain --eval --quiet --quick`
  function add_all_ssh_keys()
  {
    ssh-add $(grep -l PRIVATE ~/.ssh)
  }
  alias ssh="(ssh-add -l > /dev/null || add_all_ssh_keys ) && ssh"
else
  echo "Keychain not installed"
fi

#------------------------------
# History
#------------------------------

export HISTCONTROL=ignorespace:ignoredups
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=99999
export HISTFILESIZE=999999
export SAVEHIST=$HISTSIZE
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

#------------------------------
# Variables
#------------------------------

export EDITOR="nvim"
export PAGER="less"
# F@CK Spring
export DISABLE_SPRING=1

#------------------------------
# Aliases
#------------------------------

alias tmux="tmux -u -S /tmp/tmux-sock-$me"

alias millis='python -c "import time; print(int(time.time()*1000))"'

alias vim='nvim'
alias view='nvim -M'

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
