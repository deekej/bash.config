# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

# Source the default system configuration for bash:
if [ -z "${BASHSOURCED}" ] && [ -r /etc/bashrc ]; then
  source /etc/bashrc
fi

# --------------------------------- #

# Set the custom Bash prompt:
if hostname | grep -qi 'toolbox'; then
  # Clear the error message about ZSH not being available:
  [ -x /usr/bin/clear ] && reset

  # Obtains name of current Toolbox:
  eval $(cat /run/.containerenv | grep -e 'name=')

  [[ "${name}" == fedora-toolbox-* ]] && name='default'

  PS1="\[\033[01;35m\]\h-${name:='default'}\[\033[01;37m\]"
elif hostname | grep -qi 'stage'; then
  PS1='\[\033[01;33m\]\h-staging\[\033[01;37m\]'
else
  PS1='\[\033[01;33m\]\h\[\033[01;37m\]'
fi

if [ ${EUID} -eq 0 ] ; then
  PS1="${PS1}[\[\033[01;31m\]\u\[\033[01;37m\]] \[\033[01;34m\]\w \$\[\033[00m\] "
else
  PS1="${PS1}[\[\033[01;32m\]\u\[\033[01;37m\]] \[\033[01;34m\]\w \$\[\033[00m\] "
fi

export HISTFILE="${HOME}/.bash/history"
export HISTSIZE=10240
export HISTFILESIZE=102400
export HISTCONTROL=ignoreboth:erasedups

# Check the window size after each command and,
# update the values of LINES and COLUMNS if necessary:
shopt -s checkwinsize

# Append to the history file, don't overwrite it:
# (i.e. turn on parrallel history)
shopt -s histappend
history -a

if [ "$(uname -n)" != Normandy-SR* ]; then
  # Enabling the legacy bash completion feature (if it exists):
  if [ -r /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
  elif [ -r /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
  fi

  # Enable autocompletion for 'kubectl', if k8s is installed:
  if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash)
  fi

  # --------------------------------- #

  if command -v colordiff &> /dev/null; then
    alias diff='colordiff -uprN'
  else
    alias diff='diff -uprN'
  fi

  # Enable colors for common commands:
  alias   ls='ls   --color=auto -v -CF'
  alias  dir='vdir --color=auto'
  alias vdir='vdir --color=auto'

  alias dd='dd status=progress'
  alias df='df -h'
  alias du='du -h'
  alias la='ls -lhvAF --color=auto'
  alias ll='ls -ohvAF --color=auto --group-directories-first'
  alias lr='ls -ohvAF --color=auto --group-directories-first --reverse'
  alias rm='rm -i'

  alias  grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
  alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
  alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

  alias  less='less -R'

  alias tracert='traceroute'
  alias ipconfig='ifconfig'
  alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'
fi

# Source the shared configuration, custom aliases, and defaults overrides:
if [ -r /etc/profile.d/global-environment.sh ]; then
  source /etc/profile.d/global-environment.sh
elif [ -r "${HOME}/.profile.d/global-environment.sh" ]; then
  source "${HOME}/.profile.d/global-environment.sh"
elif [ -r "${ZDOTDIR}/profile.d/global-environment.sh" ]; then
  source "${ZDOTDIR}/profile.d/global-environment.sh"
fi
