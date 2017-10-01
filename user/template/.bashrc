source ~/.prefs
source ~/.trac
# enable color support of ls and also add handy aliases
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# this so user and host show something short and sensible
PS1='\u@\h:\w\$ '

# this so user and host show something short and sensible
# Don't change these, change PS1 above instead
PS1="${PS1//\\u/$USER}"
PS1="${PS1//\\h/sd$SDNUM}"
PS1="${PS1//\\w/\$(printf \$\{PWD/\$MAIN/≈\})}"
export PS1

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export SAGE_ATLAS_LIB=/usr/lib/   # do not build ATLAS
export SHELL=/bin/bash
export SMC=$MAIN/.smc
# We use a common ccache directory and set reasonable defaults
export CCACHE_DIR="$MAIN/.ccache"
export PATH="/usr/lib/ccache:$PATH"
ccache -F 0 > /dev/null
ccache -M 10 > /dev/null
# The following makes git use the correct ssh key
export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa"
source $MAIN/.git-completion.bash
