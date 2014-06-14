# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#I set them to unlimited
export HISTSIZE=
export HISTFILESIZE=

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# If this is an xterm set the title to user@host:dir


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='git status'



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
	 # ignore case
	 bind "set completion-ignore-case on"
	 # make it so you don't have to double click to show ambiguous

fi

if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
    export LESS=' -R '
else
    echo "need source-highlight package for highlighting in less"
fi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'
PATH="$HOME/bin:$PATH"


function git_branch(){
	 if git rev-parse --abbrev-ref HEAD >/dev/null 2>/dev/null
	 then
		  if (git status | grep -q "working directory clean" )
		  then
				echo -n " ($(git rev-parse --abbrev-ref HEAD))"
		  else
				echo -n " ($(git rev-parse --abbrev-ref HEAD)*)"
		  fi
	 fi
}
function host_name(){
	test -n "$SSH_TTY" && echo "@$HOSTNAME"
}

PS1='\[\033]0;\u$(host_name): \w\007\]\[\033[01;32m\]\u$(host_name)\[\033[00m\]:\[\033[01;34m\]\w$(git_branch) $\[\033[00m\] '

# /home is a symlink to /nfs/home, correct it so we get a tilde
[ $(pwd) == "/nfs$HOME" ] && cd $HOME

#bind F5 to previous make command
#to find escape character from F5 hit C-v and the F5
bind '"\e[15~": "!make\n"'

#load xilinx tools
XILINX_TOOLS="/nfs/opt/xilinx/latest/ISE_DS/settings64.sh"
if test -f $XILINX_TOOLS
then
 source $XILINX_TOOLS >/dev/null
 export XILINXD_LICENSE_FILE=2100@vax
fi
unset XILINX_TOOLS

#load altera path
export EDITOR=vim


get(){
	awk "{print \$$1}"
}

calc(){
	 EXPRN=$(echo "'$@'")
	 echo -n $EXPRN
	 echo -n " = "
	 python -c "
from __future__ import division
from math import *
print eval($EXPRN)"
}
export ORGANIZATION="Vectorblox Computing Inc."

make_filter(){
 	 local RED=`echo -e '\033[1;31m'`
	 local YELLOW=`echo -e '\033[1;33m'`
	 local NORMAL=`echo -e '\033[0m'`
	 sed -e "s/\(^.*:[0-9]*:[0-9]*:* error\)/$RED \1 $NORMAL/"\
        -e "s/\(^.*:[0-9]*:[0-9]*:* warning\)/$YELLOW \1 $NORMAL/"
}

make(){
	 /usr/bin/make $@ 2> >(make_filter>&2)
}

#give us a cute little saying at the beginning of our session
fortune
