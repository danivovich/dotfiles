PATH=/usr/local/bin:/usr/local/sbin:$PATH

#------------------------------
# RVM
#------------------------------
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
