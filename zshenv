PATH=/usr/local/bin:/usr/local/sbin:$PATH

if [ -e /home/dan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [[ -r "$HOME/.rover/env" ]]; then
  source "$HOME/.rover/env"
fi
