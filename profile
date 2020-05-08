# .bash_profile: executed by the command interpreter for login shells.

# Is bash running?
if [ -n "$BASH_VERSION" ]; then
  # Get the aliases, functions and overrides:
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# Disabling messages receiving when logged as root:
if [ "$(id -u)" = "0" ]; then
  mesg n
else
  mesg y
fi

# Switching to different directory if needed (sudo hook):
#if [ -e /tmp/xhost-cwd ]; then
#  cd "$(cat /tmp/xhost-cwd)"
#  rm -f /tmp/xhost-cwd
#fi
