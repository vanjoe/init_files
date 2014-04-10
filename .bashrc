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
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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
alias gd='git diff'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
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
		  echo "($(git rev-parse --abbrev-ref HEAD))"
	 fi
}
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch)$ '

# /home is a symlink to /nfs/home, correct it so we get a tilde
[ $(pwd) == "/nfs$HOME" ] && cd $HOME

#bind F5 to previous make command
#to find escape character from F5 hit C-v and the F5
bind '"\e[15~": "!make\n"'

#load xilinx tools
XILINX_TOOLS="/nfs/opt/xilinx/latest/ISE_DS/settings64.sh"
test -f $XILINX_TOOLS && source $XILINX_TOOLS >/dev/null
export XILINXD_LICENSE_FILE=2100@vax
unset XILINX_TOOLS

export EDITOR=vim
#start emacs server
emacs --daemon 2>/dev/null

e() {
  emacsclient -c $1
  wmctrl -xa emacs
}

get(){
	awk "{print \$$1}"
}

export ORGANIZATION="Vectorblox Computing Inc."
#give us a cute little saying at the beginning of our session
fortune
