#!/bin/bash

# vim
if [ ! -e ~/.vim ]; then
  ln -s ~/.dotfiles/vim ~/.vim
fi 
if [ ! -e ~/.vimrc ]; then
  ln -s ~/.dotfiles/vimrc ~/.vimrc
fi
if [ ! -e ~/.gvimrc ]; then
  ln -s ~/.dotfiles/gvimrc ~/.gvimrc
fi

# gemrc
if [ ! -e ~/.gemrc ]; then
  ln -s ~/.dotfiles/gemrc ~/.gemrc
fi

# screenrc
if [ ! -e ~/.screenrc ]; then
  ln -s ~/.dotfiles/screenrc ~/.screenrc
fi

# tmux
if [ ! -e ~/.tmux.conf ]; then
  ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
fi

# ackrc
if [ ! -e ~/.ackrc.conf ]; then
  ln -s ~/.dotfiles/ackrc ~/.ackrc
fi

# Submodules
git submodule init
git submodule update

# oh-my-zsh
if [ ! -e ~/.oh-my-zsh ]; then
  ln -s ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
fi

if [ ! -e ~/.zshrc ]; then
  ln -s ~/.dotfiles/zshrc ~/.zshrc
fi

if [ ! -e ~/.dotfiles/vim/bundle/command-t/ruby/command-t/ext.so ]; then
  if [ -e ~/.rvm/bin/rvm ]; then
    rubyv=`type -P ruby`
    if [ $rubyv != '/usr/bin/ruby' ]; then
      echo
      echo !!!!!!!!!!!!!!!!!!!!!!!!!!!
      echo
      echo rvm is installed, set ruby to system and rerun script!
      echo
      echo !!!!!!!!!!!!!!!!!!!!!!!!!!!
      echo
      exit
    fi
  fi

  cd ~/.dotfiles/vim/bundle/command-t/
  rake make
fi
