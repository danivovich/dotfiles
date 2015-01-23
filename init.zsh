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

# Submodules
git submodule status | grep '^\-.*'
if [ "$?" = "0" ]; then
  git submodule init
  git submodule update
fi

# oh-my-zsh
if [ ! -e ~/.oh-my-zsh ]; then
  ln -s ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
fi

if [ ! -e ~/.zshrc ]; then
  ln -s ~/.dotfiles/zshrc ~/.zshrc
fi

if [ ! -e ~/.zshenv ]; then
  ln -s ~/.dotfiles/zshenv ~/.zshenv
fi

cd ~/.dotfiles/zsh_custom_plugins
for plugin_dir in *
do
  mkdir -p ~/.dotfiles/oh-my-zsh/custom/plugins
  if [ ! -e ~/.dotfiles/oh-my-zsh/custom/plugins/$plugin_dir ]; then
    ln -s ~/.dotfiles/zsh_custom_plugins/$plugin_dir ~/.dotfiles/oh-my-zsh/custom/plugins/$plugin_dir
  fi
done


# Vundle install
cd ~/.dotfiles
mv vimrc vimrc.bak
sed 's/colorscheme solarized/" colorscheme solarized/' vimrc.bak > vimrc
vim +PluginInstall +qall
mv vimrc.bak vimrc
