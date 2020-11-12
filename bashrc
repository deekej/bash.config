# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source the default system configuration for bash:
if [ -z "$BASHSOURCED" ] && [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# --------------------------------- #

if [[ "$(uname -n)" == Normandy-SR* ]]; then
  export HISTFILE="$HOME/.bash/history"

  export HISTSIZE=10240
  export HISTFILESIZE=102400

  export HISTCONTROL=ignoreboth:erasedups

  # --------------------------------- #

  # Set the appropriate font size for TTY:
  if [ -z "$DISPLAY" ]; then
    if xrandr -d :0 --listmonitors | grep -q 'XWAYLAND1'; then
      setfont ter-m16v  # Smaller font for external display.
    else
      setfont ter-m20b  # Bigger font for dedicated screen.
    fi
  fi

  # --------------------------------- #

  # Source the shared configuration, custom aliases, and defaults overrides:
  if [ -f /etc/profile.d/global-environment.sh ]; then
    source /etc/profile.d/global-environment.sh
  fi
else
  # Check the window size after each command and,
  # update the values of LINES and COLUMNS if necessary:
  shopt -s checkwinsize

  # Append to the history file, don't overwrite it:
  # (i.e. turn on parrallel history)
  shopt -s histappend
  history -a

  # --------------------------------- #

  # NOTE: We expect that every terminal nowadays supports the colored output.

  # Enable colors for ls, etc., and prefer ~/.dir_colors:
  if type -P dircolors >/dev/null ; then
    if [ -f ~/.dir_colors ] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [ -f /etc/DIR_COLORS ] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    else
      eval $(dircolors)
    fi
  fi

  # Set the custom Bash prompt:
  if [ ${EUID} -eq 0 ] ; then
    PS1='\[\033[01;33m\]\h\[\033[01;37m\][\[\033[01;31m\]\u\[\033[01;37m\]] \[\033[01;34m\]\w \$\[\033[00m\] '
  else
    PS1='\[\033[01;33m\]\h\[\033[01;37m\][\[\033[01;32m\]\u\[\033[01;37m\]] \[\033[01;34m\]\w \$\[\033[00m\] '
  fi

  # Enabling the legacy bash completion feature (if it exists):
  if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
  elif [ -f /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
  fi

  # Enable autocompletion for 'kubectl', if k8s is installed:
  if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash)
  fi

  # Enable colors for common commands:
  alias     ls='ls   --color=auto -v -CF'
  alias    dir='vdir --color=auto'
  alias   vdir='vdir --color=auto'

  alias   grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
  alias  fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
  alias  egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

  alias   less='less -R'

  if command -v colordiff &> /dev/null; then
    alias diff='colordiff -uprN'
  else
    alias diff='diff -uprN'
  fi

  # --------------------------------- #

  # Global alias definitions:
  alias dd='dd status=progress'
  alias df='df -h'
  alias du='du -h'
  alias la='ls -lhvAF --color=auto'
  alias ll='ls -ohvAF --color=auto --group-directories-first'
  alias lr='ls -ohvAF --color=auto --group-directories-first --reverse'
  alias rm='rm -i'

  # --------------------------------- #
  # Useful workflow aliases:
  # --------------------------------- #

  # Network section:
  # ----------------
  alias tracert='traceroute'
  alias ipconfig='ifconfig'
  alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

  # Security section:
  # -----------------
  alias su='su -'
  alias pwgen='pwgen -scnyB'
  alias PINgen="hexdump -n 2 -e '1/1 \"%03u\"' /dev/urandom; echo \"\""

  # Workflow section:
  # -----------------
  alias make='make -j'

  # Source the shared configuration, custom aliases, and defaults overrides:
  if [ -f ~/.profile.d/global-environment.sh ]; then
    source  ~/.profile.d/global-environment.sh
  fi
fi
