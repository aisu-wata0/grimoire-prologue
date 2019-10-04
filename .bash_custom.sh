# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

## Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# OpenVino #-
alias openvinoVars="source /opt/intel/openvino/bin/setupvars.sh"
# -# OpenVino

# https://stackoverflow.com/questions/6339287/copy-or-rsync-command
# rsync is superior
alias cp="rsync -ah --inplace --no-whole-file --info=progress2"

alias appget="sudo aptitude"
# ls aliases
## Colorize the ls output ##
alias ls='ls --color=auto'
# h = readable file size
alias ll='ls -lh --color=auto'
# S = sort by file size
alias lhs='ls -lhS --color=auto'
# A = list all
alias la='ls -lhA --color=auto'
# A = list all
alias lahs='ls -lhAS --color=auto'
# t = sort my modification date
alias lt='ls -lht --color=auto'

##

# tab size
tabs -3

## GIT PS1
if [ ! -f ~/.bash_git ]; then
    echo "~/.bash_git not found, downloading"
    curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
fi

GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true

source ~/.bash_git
## GIT PS1

# SSH AGENT for ssh keys
eval "$(ssh-agent -s)"

#[usr@machine] [path] $
#
PS1='\n${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] \[\033[01;34m\][\w] \033[33;1m[$(date +%Y%m%d_%H%M)]\e[0m$(__git_ps1) \$\n'
PROMPT_COMMAND='__git_ps1 "\n($CONDA_DEFAULT_ENV) ${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] \[\033[01;34m\][\w] \033[33;1m[$(date +%Y%m%d_%H%M)] \e[0m" "\\\$\n"'

# Comand History

## 100K lines is around one 10MB

HISTSIZE=100000
HISTFILESIZE=100000

## don't put duplicate lines or lines starting with space in the history.
## See bash(1) for more options

HISTCONTROL=ignoreboth

## append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned off
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# mouse acc

## https://forums.linuxmint.com/viewtopic.php?t=208817
## https://wiki.archlinux.org/index.php/Mouse_acceleration
## ignore errors
xinput --set-prop 11 "Device Accel Velocity Scaling" 1 2>  /dev/null
xinput --set-prop 11 "Device Accel Profile" -1 2>  /dev/null
xinput --set-prop 11 "Device Accel Adaptive Deceleration" 4 2>  /dev/null


# conda breaks gsettings path
# https://askubuntu.com/questions/558446/my-dconf-gsettings-installation-is-broken-how-can-i-fix-it-without-ubuntu-reins
alias gsettings=/usr/bin/gsettings

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/devsoft/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/devsoft/miniconda3/etc/profile.d/conda.sh" ]; then
        . "~/devsoft/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:~/devsoft/miniconda3/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval "$('/e/dev/Miniconda3/Scripts/conda.exe' 'shell.bash' 'hook' 2> /dev/null)"
# <<< conda initialize <<<
