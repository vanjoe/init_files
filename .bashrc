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

###############
#PS1 GENERATION
function git_branch(){
	local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ -n "$BRANCH" ]
	then
		 echo -n "($BRANCH)"
	fi
}
function num_job(){
	 local NUM_JOBS=$(jobs | wc -l)
	 [ $NUM_JOBS -gt 0 ] && echo "(jobs:$NUM_JOBS)"
}
if [ -n "$SSH_TTY" ]
then
	 PS1='\[\033]0;\u@\h: \w\007\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w $(git_branch)\n \$\[\033[00m\] '
else
	 PS1='\[\033]0;\u: \w\007\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w $(git_branch)\n \$\[\033[00m\] '
fi

# /home is a symlink to /nfs/home, correct it so we get a tilde
cd $( pwd | sed -e "s|/nfs\($HOME.*\)|\1|")

#bind F5 to previous make command
#to find escape character from F5 hit C-v and the F5
bind '"\e[15~": "!make\n"'

#load xilinx tools

function load_xilinx(){
	 local SETTINGS="$1/settings64.sh"
	 if test -f $SETTINGS
	 then
		  source $SETTINGS >/dev/null
		  export XILINXD_LICENSE_FILE=2100@vax
	 else
		  echo "Unable to Open $SETTINGS" >/dev/stderr
	 fi
}
function load_ise(){
	 local ISE_DIR="/nfs/opt/xilinx/latest/ISE_DS/"
	 load_xilinx $ISE_DIR
	 export XILINX_ISE=1
}
function load_vivado(){
	 local VIV_DIR="/nfs/opt/xilinx/Vivado/latest/"
	 load_xilinx $VIV_DIR
	 export XILINX_VIVADO=1
}

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
export VECTORBLOX_SIM_LICENSE="PXOENCVQONIDQALT"
make_filter(){
 	 local RED=`echo -e '\033[1;31m'`
	 local YELLOW=`echo -e '\033[1;33m'`
	 local GREEN=`echo -e '\033[1;32m'`
	 local NORMAL=`echo -e '\033[0m'`
	 sed -e "s/\(^.*:[0-9]*:[0-9]*:* error\)/$RED \1 $NORMAL/"\
        -e "s/\(^.*:[0-9]*:[0-9]*:* warning\)/$YELLOW \1 $NORMAL/"\
        -e "s/\(^.*:[0-9]*:[0-9]*:* note\)/$GREEN \1 $NORMAL/"

}

make(){
	 if [ -t 2 ] #if stderr is a tty, color output
	 then
		  /usr/bin/make $@ 2> >(make_filter>&2)
	 else   #run  make normally
		  /usr/bin/make $@
	 fi
}

#give us a cute little saying at the beginning of our session
command fortune >/dev/null 2>&1 && fortune

git-top(){
	 git rev-parse --show-toplevel
}
init_vblox(){
	 pushd $(git-top) > /dev/null
	 cp example_config.mk config.mk
	 cp example_program.mk program.mk
	 popd >/dev/null
}
git-origin(){
	 pushd $(git-top) > /dev/null
	 grep -C1 "\[remote" .git/config
	 popd >/dev/null
}
### ONE LINERS ###
#set baud rate
# stty -F /dev/ttyACM0 9600

#list contents of tarball
#tar -tvf file.tar
#tar -ztvf file.tar.gz
#tar -jtvf file.tar.bz2

#get top level dir of git repo
#git rev-parse --show-toplevel

#print git DAG in terminal
#git log --all --graph --decorate --oneline
