
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

condainit_linux_dir(){
    # ### conda initialize ###
    CONDA_DIR="$1"
    if [ ! -d "$CONDA_DIR" ]; then
        return 1;
    fi;
    __conda_setup="$("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then
            . "$CONDA_DIR/etc/profile.d/conda.sh"
        else
            export PATH="$PATH:$CONDA_DIR/bin"
        fi
    fi
    unset __conda_setup
    # ### conda initialize ###
}

condainit_linux(){
    condainit_linux_dir "$HOME/.local/miniconda3" || {
    condainit_linux_dir "$HOME/miniconda3" || {
    condainit_linux_dir "$HOME/devsoft/miniconda3"
    }
    }
}

condainit_windows_dir(){
    CONDA_DIR="$1"
    if [ ! -d "$CONDA_DIR" ]; then
        return 1;
    fi;
    "$CONDA_DIR"/activate
}

condainit_windows(){
    # ### conda initialize ###
    # eval "$('~/.local/Miniconda3/Scripts/conda.exe' 'shell.bash' 'hook' 2> /dev/null)"
    condainit_windows_dir "~/miniconda3/Scripts" || {
    condainit_windows_dir "~/.local/Miniconda3/Scripts"
    }
    conda activate base
    # ### conda initialize ###
}

condainit(){
    condainit_linux
    condainit_windows
}

condainit
# conda breaks gsettings path
# https://askubuntu.com/questions/558446/my-dconf-gsettings-installation-is-broken-how-can-i-fix-it-without-ubuntu-reins
alias gsettings=/usr/bin/gsettings

# ## Node

export NODE_OPTIONS=--max_old_space_size=32768

# # Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# keep aliases on sudo
alias sudo='sudo '

# ## OpenVino
alias openvinoVars="source /opt/intel/openvino/bin/setupvars.sh"
# <<< OpenVino

# ## cp -> rsync
# https://stackoverflow.com/questions/6339287/copy-or-rsync-command

if command -v rsync &> /dev/null; then
    # -a, --archive
    #        This is equivalent to -rlptgoD. It is a quick way  of  saying  you  want  recursion  and  want  to
    #        preserve  almost  everything  (with -H being a notable omission).  The only exception to the above
    #        equivalence is when --files-from is specified, in which case -r is not implied.
    #
    #        Note that -a does not preserve hardlinks, because finding multiply-linked files is expensive.  You
    #        must separately specify -H
    # -h, --human-readable
    # -i, --itemize-changes
    #    Requests  a  simple  itemized  list  of  the  changes  that are being made to each file, including
    #    attribute changes.  This is exactly the same as specifying --out-format='%i %n%L'.  If you  repeat
    #    the  option,  unchanged  files  will  also  be output, but only if the receiving rsync is at least
    #    version 2.6.7 (you can use -vv with older versions of rsync, but that also turns on the output  of
    #    other verbose messages)..
    # # Not used:
    # -o, --owner                 preserve owner (super-user only)
    # -g, --group                 preserve group
    alias cprsync="rsync -a --no-o --no-g -e ssh --partial-dir=.rsync-partial  -hi --info=progress2"
fi

# <<< cp -> rsync <<<

alias appget="sudo aptitude"
alias del="rm -i"
alias rmi="rm -i"
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
# -t = sort my modification date
alias llt='ls -h -lt --color=auto'
alias lat='ls -h -lAt --color=auto'
# -v     natural sort of (version) numbers within text
alias lv='ls -h -v --color=auto'

alias ffmpeg='ffmpeg -hide_banner'

alias yt-dla='yt-dlp.exe   --fragment-retries "123"  --cookies c.txt  -f "(bestaudio)" -x  --add-metadata  --embed-thumbnail -o "%(title)s [%(upload_date)s][%(id)s].%(ext)s" '
alias yt-dl='yt-dlp.exe   --fragment-retries "123"  --cookies c.txt  -f "(bestvideo+bestaudio/best)"   --add-metadata  --embed-thumbnail -o "%(title)s [%(upload_date)s][%(id)s].%(ext)s" '
alias yt-dlh='yt-dlp.exe   --fragment-retries "123"  --cookies c.txt  -f "(bestvideo+bestaudio/best)"   --add-metadata  --embed-thumbnail -o "%(title)s [%(upload_date)s][%(id)s].%(ext)s" '

alias yt-dl_wait='yt-dlp.exe   --fragment-retries "123"  --cookies c.txt  -f "(bestvideo+bestaudio/best)"   --add-metadata  --embed-thumbnail -o "%(title)s [%(upload_date)s][%(id)s].%(ext)s"  --wait-for-video 30'
alias yt-dl_from_start='yt-dlp.exe   --fragment-retries "123"  --cookies c.txt  -f "(bestvideo+bestaudio/best)"   --add-metadata  --embed-thumbnail -o "%(title)s [%(upload_date)s][%(id)s].%(ext)s"  --live-from-start'


retry_until_success(){
    echo "until $1 ; do echo "Try"; done"
}


ffmpeg_cut_audio(){
    echo ffmpeg -ss "$1" -to "$2" -i \""$3"\" -map_metadata 0 -movflags use_metadata_tags  -map 0:v -map 0:a   -c:v copy -c:a copy   \""$([ $4 ] && echo "$4" || echo "$3-cut_audio.mp3")"\"
}
alias ffmpeg_cut_audio='ffmpeg_cut_audio'

ffmpeg_cut_video(){
    echo ffmpeg -ss "$1" -to "$2" -i \""$3"\" -map_metadata 0 -movflags use_metadata_tags  -map 0:v -map 0:a   -c:v copy -c:a copy   \""$([ $4 ] && echo "$4" || echo "$3-cut_audio.mp4")"\"
}
alias ffmpeg_cut_video='ffmpeg_cut_video'

ffmpeg_cover_vid(){
    echo ffmpeg -i \""$3"\"  -map 0:v -map -0:V -c copy  \""$([ $4 ] && echo "$4" || echo "$3-cover.jpg")"\"
}
alias ffmpeg_cover_vid='ffmpeg_cover_vid'


ffmpeg_help(){
    echo ffmpeg_cut_audio 0:00:00 1:23:45 "video_name.mp3"
    echo ffmpeg_cut_video 0:00:00 1:23:45 "video_name.mp4"
    echo ffmpeg_cover_vid "video_name.mp4"
}
alias ffmpeg_help='ffmpeg_help'

stl(){
    until streamlink --hls-live-restart "$1"  best "$([ $2 ] && echo -o $2 || streamlink.ts)"; do sleep 10; done
}
alias stl='stl'

# sudo apt update        # Fetches the list of available updates
# sudo apt upgrade -y       # Installs some updates;
# sudo apt full-upgrade -y  # Installs updates; may also remove packages
# sudo apt autoremove -y    # Removes any old packages that are no longer needed
alias henshin="sudo -- sh -c 'sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y;'"
alias henshinZenbu="sudo -- sh -c 'sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y;'"
# Pretty git log/graph
alias gitgraph="git log --oneline --graph --decorate --abbrev-commit"
# Quick tmux attach
alias tata="tmux attach"
# Better rm, moves to trashcan
alias trash='mv --force -t ~/.local/share/Trash '
# Show trashcan
alias ls_trash='echo ~/.local/share/Trash && lat ~/.local/share/Trash'

# onegai | Execute the previous command as sudo
alias onegai='sudo !!'
# sayonara | Shut downs the computer
alias sayonara='shutdown -h now'


# ## tmux

alias t="exec tmux"
alias ta="exec tmux attach"
alias f="find -iname"

# <<< tmux <<<

# <<<< Alias definitions. <<<<

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

# if inside tmux
if [[ "$TERM" =~ "screen".* ]]; then
    # Print tmux instructions
    {
        echo 'Ctrl+t  Create a new window (with shell)'
        echo 'Ctrl+w  Go to the prev window'
        echo 'Ctrl+e  Go to the next window'
        echo "Ctrl+s  Toggle between last windows (or prefix+')"
        echo 'Ctrl+[  Split current pane vertically into two panes'
        echo 'Ctrl+]  Split current pane horizontally into two panes'
        echo 'Alt+arrows  To go to panes'
        echo 'prefix+w  Choose window from a list, x to kill any'
        echo 'Ctrl+D  Close the current pane'
        echo 'y       While in vi selection to copy to clipboard using xclip (and to tmux buffer)'
        echo 'Ctrl+y  To paste buffer into ~/.tmux/buffer'
        echo ':save-buffer ~/.tmux/buffer'
        echo 'prefix+/ to search, n next, shift+n previous'
        echo 'prefix+f to search windows'
    }
fi

# tab size
tabs -4 2>  /dev/null

# Comand History

# Every terminal has its history appended in the same file
# .bash_history turns into a global timeline
# this way, no command is left behind
# export PROMPT_COMMAND=${PROMPT_COMMAND}' history -a;'
export PROMPT_COMMAND=${PROMPT_COMMAND}' history -a;'
# TRAP_DEBUG_1='history -a;'

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

## don't put duplicate lines or lines starting with space in the history.
## See bash(1) for more options

export HISTCONTROL=ignoreboth

## append to the history file, don't overwrite it
shopt -s histappend


## GIT PS1
# if [ ! -f ~/.bash_git ]; then
#     echo "~/.bash_git not found, downloading"
#     curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
# fi

# export GIT_PS1_SHOWUPSTREAM="verbose"
# export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWCOLORHINTS=true

# source ~/.bash_git
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
export bash_ps1_conda="\${CONDA_DEFAULT_ENV:+(\`basename \$CONDA_DEFAULT_ENV\`) }"
export bash_ps1_venv="\${VIRTUAL_ENV:+(\`basename \$VIRTUAL_ENV\`) }"

export PS1_="${bash_ps1_location}:${bash_ps1_path} ${bash_ps1_time}${bash_reset_color}"

export PS1="${PS1_}$(__git_ps1)"$' $\n'
export PROMPT_COMMAND=${PROMPT_COMMAND}" __git_ps1 '\n${bash_ps1_conda}${bash_ps1_venv}${PS1_}' ' \\\$\n';"

# # Set window title
# [path] $PREV_COMMAND

# https://unix.stackexchange.com/questions/104018/set-dynamic-window-title-based-on-command-input

function settitle () {
    if [ -z "$PREV_COMMAND" ]; then
        export PREV_COMMAND=${@}
    fi
    current_dirname=${PWD##*/}
    current_dirname=${current_dirname:-/}
    echo -ne "\033]0;[${current_dirname}]  ${PREV_COMMAND}\007"
}

export PROMPT_COMMAND=${PROMPT_COMMAND}' export PREV_COMMAND="";'

TRAP_DEBUG_0='settitle "$BASH_COMMAND";'
trap "${TRAP_DEBUG_0}" DEBUG


# Substitute unreadable green background on blue text with underline on blue text for other writable directories.
# export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=04;30;40:ow=04;34;40:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
eval "$(dircolors ~/.dircolors)";

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
