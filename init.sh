#!/bin/bash

# vim
if [ ! -e ~/.vim ]; then
  ln -s ~/.my_config/vim ~/.vim
fi 
if [ ! -e ~/.vimrc ]; then
  ln -s ~/.my_config/vimrc ~/.vimrc
fi
if [ ! -e ~/.gvimrc ]; then
  ln -s ~/.my_config/gvimrc ~/.gvimrc
fi

# gemrc
if [ ! -e ~/.gemrc ]; then
  ln -s ~/.my_config/gemrc ~/.gemrc
fi

# screenrc
if [ ! -e ~/.screenrc ]; then
  ln -s ~/.my_config/screenrc ~/.screenrc
fi

# tmux
if [ ! -e ~/.tmux.conf ]; then
  ln -s ~/.my_config/tmux.conf ~/.tmux.conf
fi

# Submodules
git submodule init
git submodule update

# oh-my-zsh
if [ ! -e ~/.oh-my-zsh ]; then
  ln -s ~/.my_config/oh-my-zsh ~/.oh-my-zsh
fi

if [ ! -e ~/.zshrc ]; then
  ln -s ~/.my_config/zshrc ~/.zshrc
fi

if [ ! -e ~/.my_config/vim/bundle/command-t/ruby/command-t/ext.so ]; then
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

  cd ~/.my_config/vim/bundle/command-t/
  rake make
fi
