# Undo the changed home directory for cd
_cd_main ()
{
    HOME="$MAIN" \cd "$@"
}
alias cd=_cd_main
alias tmux="tmux -L $USER"

_make_nice ()
{
    if [ $# -eq 1 -a "$1" = build ]
    then
        mkdir -p "/tmp/$USER"
        tmpfile=`mktemp -p "/tmp/$USER"`
        echo "Building Sage; output is being sent to $tmpfile"
        SAGE_NUM_THREADS=40 nice ionice \make build > "$tmpfile"
        tail -n 80 "$tmpfile"
    else
        \make "$@"
    fi
}
alias make=_make_nice

alias ls='ls --color=auto'
alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'