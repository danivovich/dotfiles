#!/bin/zsh

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

#nvim
if [ ! -e ~/.config/nvim/init.lua ]; then
  ln -s ~/.dotfiles/init.lua ~/.config/nvim/init.lua
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
if [ ! -e ~/.ackrc ]; then
  ln -s ~/.dotfiles/ackrc ~/.ackrc
fi

if [ ! -e ~/.zshrc ]; then
  ln -s ~/.dotfiles/zshrc ~/.zshrc
fi

if [ ! -e ~/.zshenv ]; then
  ln -s ~/.dotfiles/zshenv ~/.zshenv
fi

if [ ! -e ~/.p10k.zsh ]; then
  ln -s ~/.dotfiles/p10k.zsh ~/.p10k.zsh
fi

# psql
if [ ! -e ~/.psqlrc ]; then
  ln -s ~/.dotfiles/psqlrc ~/.psqlrc
fi
