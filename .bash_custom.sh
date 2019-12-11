
if [ ! $DOT_PROFILE_SOURCED ]; then
    # echo "      .bash_custom: profile"
    . ~/.profile 2> /dev/null;
fi
if [ ! $DOT_BASHRC_SOURCED ]; then
    # echo "      .bash_custom: bashrc"
    . ~/.bashrc 2> /dev/null;
fi
if [ ! $DOT_BASHPROFILE_SOURCED ]; then
    # echo "      .bash_custom: bash_profile"
    . ~/.bash_profile 2> /dev/null;
fi

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;; # interactive
    *) return;; # not interactive
esac

# Start tmux ٩(◕‿◕｡)۶
# tmux on windows git bash  
# https://gist.github.com/lhsfcboy/f5802a5985a1fe95fddb43824037fe39
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
  tmux
fi

echo
echo '# Tmux'
echo 'Ctrl+t  Create a new window (with shell)'
echo 'Ctrl+w  Go to the prev window'
echo 'Ctrl+e  Go to the next window'
echo "p '  Toggle between last windows"
echo 'Ctrl+[  Split current pane vertically into two panes'
echo 'Ctrl+]  Split current pane horizontally into two panes'
echo 'Alt+arrows  To go to panes'
echo 'p w  Choose window from a list, x to kill any'
echo 'Ctrl+D  Close the current pane'
echo

# To setup tmux on windows
# https://gist.github.com/lhsfcboy/f5802a5985a1fe95fddb43824037fe39
# You can install the whole distribution of the tools from https://www.msys2.org/ and run a command to install Tmux. (GIT Bash uses MINGW compilation of GNU tools. It uses only selected ones.)
# And then copy some files to installation folder of Git. This is what you do:

# Install before-mentioned msys2 package and run bash shell
# Install tmux using the following command: pacman -S tmux
# Go to msys2 directory, in my case it is C:\msys64\usr\bin
# Copy tmux.exe and msys-event-2-1-4.dll to your Git for Windows directory, mine is C:\Program Files\Git\usr\bin

# https://github.com/valtron/llvm-stuff/wiki/Set-up-Windows-dev-environment-with-MSYS2
# MSYS2
# Note: $VARS refer to strings you should substitute yourself. E.g. $DEV -> D:/dev

# Download from http://msys2.github.io
# Install into $DEV/msys64
# Run $DEV/msys2_shell.cmd
# Run pacman -Syuu
# Close the shell; reopen it, and run pacman -Syuu again, just in case :p
# Pacman
# pacman is the package manager bundled with msys. Use it to install useful things like gcc, flex, bison, git. The commands are pretty cryptic, so use the Pacman/Rosetta.

# Set up $PATH
# Open "Environment Variables > System Variables > Path"
# At the end, add $DEV/msys64/usr/bin

# Print ASCII art
. ~/.ascii/art.sh

## Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# OpenVino #-
alias openvinoVars="source /opt/intel/openvino/bin/setupvars.sh"
# -# OpenVino

# https://stackoverflow.com/questions/6339287/copy-or-rsync-command
# rsync is superior

if command -v rsync &> /dev/null; then
    # -a, --archive
    #        This is equivalent to -rlptgoD. It is a quick way  of  saying  you  want  recursion  and  want  to
    #        preserve  almost  everything  (with -H being a notable omission).  The only exception to the above
    #        equivalence is when --files-from is specified, in which case -r is not implied.
    #
    #        Note that -a does not preserve hardlinks, because finding multiply-linked files is expensive.  You
    #        must separately specify -H
    # -u, --update
    #    This forces rsync to skip any files which exist on the destination and have a modified  time  that
    #    is  newer than the source file.  (If an existing destination file has a modification time equal to
    #    the source file’s, it will be updated if the sizes are different.

    # -i, --itemize-changes
    #    Requests  a  simple  itemized  list  of  the  changes  that are being made to each file, including
    #    attribute changes.  This is exactly the same as specifying --out-format='%i %n%L'.  If you  repeat
    #    the  option,  unchanged  files  will  also  be output, but only if the receiving rsync is at least
    #    version 2.6.7 (you can use -vv with older versions of rsync, but that also turns on the output  of
    #    other verbose messages)..
    alias cp="rsync -au -e ssh --partial-dir=.rsync-partial  -hi --info=progress2"
fi

alias appget="sudo aptitude"
# ls aliases
## Colorize the ls output ##
# -h = readable file size
alias ls='ls -h --color=auto'
alias ll='ls -h -l --color=auto'
# -A = list all
alias la='ls -h -lA --color=auto'
# -S = sort by file size
alias lls='ls -h -lS --color=auto'
alias las='ls -h -lAS --color=auto'
# t = sort my modification date
alias llt='ls -h -lt --color=auto'
alias lat='ls -h -lAt --color=auto'

# sudo apt update        # Fetches the list of available updates
# sudo apt upgrade -y       # Installs some updates;
# sudo apt full-upgrade -y  # Installs updates; may also remove packages
# sudo apt autoremove -y    # Removes any old packages that are no longer needed

alias henshin="sudo -- sh -c 'sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y;'"
alias t="exec tmux"
alias ta="exec tmux attach"
alias f="find -iname"

##

# tab size
tabs -4 2>  /dev/null

# Comand History

# Every terminal has its history appended in the same file
# .bash_history turns into a global timeline
# this way, no command is left behind
export PROMPT_COMMAND=${PROMPT_COMMAND}' history -a;'

## 100K lines is around one 10MB

export HISTSIZE=$((100*1000)) # stored in memory
export HISTFILESIZE=$((2000*1000)) # stored in file

## don't put duplicate lines or lines starting with space in the history.
## See bash(1) for more options

export HISTCONTROL=ignoreboth

## append to the history file, don't overwrite it
shopt -s histappend


## GIT PS1
if [ ! -f ~/.bash_git ]; then
    echo "~/.bash_git not found, downloading"
    curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
fi

export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true

source ~/.bash_git
## PS1

# (conda env) (chroot)[usr@machine] [path] [datetime] (git branch sync) $
#
# https://stackoverflow.com/questions/33220492/ps1-bash-command-substitution-not-working-on-windows-10
export bash_reset_color="\[\e[0m\]"
export bash_blue="\[\033[01;34m\]"
export bash_yellow="\[\033[33;1m\]"
export bash_ps1_location="\${debian_chroot:+(\$debian_chroot)}${bash_yellow}\u@\h"
export bash_ps1_path="${bash_blue}\w"
export bash_ps1_time="${bash_yellow}[\D{%F %T}]"
export bash_ps1_conda="\${CONDA_DEFAULT_ENV:+(\$CONDA_DEFAULT_ENV) }"

export PS1_="${bash_ps1_location}:${bash_ps1_path} ${bash_ps1_time}${bash_reset_color}"

export PS1="${PS1_}$(__git_ps1)"$' $\n'
export PROMPT_COMMAND=${PROMPT_COMMAND}" __git_ps1 '\n${bash_ps1_conda}${PS1_}' ' \\\$\n';"

# # Set window title
# [path] $PREV_COMMAND

# https://unix.stackexchange.com/questions/104018/set-dynamic-window-title-based-on-command-input

function settitle () {
    if [ -z "$PREV_COMMAND" ]; then
        export PREV_COMMAND=${@}
    fi
    echo -ne "\033]0;[$(pwd)]  ${PREV_COMMAND}\007"
}

export PROMPT_COMMAND=${PROMPT_COMMAND}' export PREV_COMMAND="";'

trap 'settitle "$BASH_COMMAND"' DEBUG


# # check the window size after each command and, if necessary,
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


# ## SSH Agent autostart
# Auto start ssh-agent if necessary
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    case $- in
        *i*) echo "Initialising new SSH agent...";; # interactive
        *) ;; # not interactive
    esac
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -p ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    # ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# ## Conda initialize

condainit(){
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
}
