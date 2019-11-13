# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Start tmux ٩(◕‿◕｡)۶

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
  exec tmux
fi

echo
echo '# Tmux'
echo 'Ctrl+b c  Create a new window (with shell)'
echo 'Ctrl+b w  Choose window from a list, x to kill any'
echo 'Ctrl+b 0  Switch to window 0 (by number)'
echo 'Ctrl+b %  Split current pane horizontally into two panes'
echo 'Ctrl+b "  Split current pane vertically into two panes'
echo 'Ctrl+b o  Go to the next pane'
echo 'Ctrl+b ;  Toggle between the current and previous pane'
echo 'Ctrl+b x  Close the current pane'
echo 'Ctrl+b ,  Rename the current window'
echo '# Tmux'
echo

# . './ascii/all120.sh'
echo '/-/--:--.+:```.:-.`-:/+os:/+/.    .-//::---:-------------------------:/++:----:o+++++//:::/:.:-.:-:.  `  oysoo+:..:..  `'
echo '.:......:+-.````.:+/://+:-+::/-`-/::-----::--------------------:--------/++/:--++++++++++/:::::-:+`  ` `:ohdhyoo+:`:-```'
echo '.:.......-/+/--::/y/:.` `.-/+++::-------::----------------------::--------/o+//+++++++++++++/:::/`  `  .oyddddhyso:+--.`'
echo '.......//:/:::://o-.`...--/+o:--------::-----------------------:-:/----..--:+o+o+++++oo+++++++/::-`  `./shddddddhyss/--:'
echo '..-://sh++/+++/::.```...:++:---------::-------------------------/-:+:--.`.---/o++++++++ooo++++++/::-`.:shdddddddddhyoo:/'
echo '+::-::--..``````````..-::-----------:/---------------/----------:/-:o:.------:+yo++++++++oso+++++/:://oyddddddddddddhoo+'
echo '`````````````...--:::/:.-----------:+----------------/o----------+/-/o:-----/++oyso++++++++sso+++++/ossddddddddddddddhss'
echo '```````..--::::::::/+.`------:-----/------------------ss---------++/-/o:--/+++++oyso++++++++osoo+++yoshdddddddddddddddds'
echo '```.-:////::::::::+/``------:------:.--------------::-:h+--------/++/:+s+++++++++oyso+++++++++ssosyoshdddddddddddddddddd'
echo '--:::::::::::::::+:``-------:------:.---------------+--++/-------/++o++oys++++++++syso+++++++++sssshdddddddddddddddddddd'
echo '+:::::::::::::::/-``-------::-----:..---------------o+--+-/-----:++++s++sho++++++++ysso++ooosssyhhdddddddddddddddhhhdddd'
echo '///////////////:.``--------/------:..---::-------..-+y:-+:-/--:+++++++s+oss+++++++++yssssyyyhhdddddddddddddddddho///+ydd'
echo '+//////osyo///+-.`---------+------:..`..:+-------..-+s+::o`//+ooooooo+so+s-s++++++++odddddddddddddddddddddddddy//-.`::/y'
echo '::::/+ooo::::/-/`.--------/o------:-````-o----------++o/:s:-o++++++++++s+s`:o++++++++ydddddddddddddddddddddddy/.:.`:::.-'
echo ':/+++//+o:::/-+`.---.-----+o-------/```.-s----------o+s:/o+`.o+++++++++o+o``+++++++++oddddddddddddddddhyssydys:.-..`` `:'
echo '++:::/.://:/:-:`----.----:oy:------s`----s:--------:o+s.o+o``:+++++++//++o```o+++++++oydddddddddddddho+++/-+yo+..    `:-'
echo ':-``````.o:+`o`.---.`.---/oh+------y:.---++--------/o+o/:+s```o////+//::+:`` :o++++++o+hsssydddddddyo+++++/-s+o..`   ++o'
echo '`````````++-.+``.--.`.--:+oyo/-----o:.---:y--------+o+++`ss```::oyhddddhho/`  o++++++o+yso+++shddysos++++++:o+o:.:.-:ooo'
echo '`````````++`+..---------/+o:o+/----+./.---y+-------++++o`+o``-sdmhso+//+shmd/`.s++++++osss+++++yhy++s++++++//o++.--.-://'
echo '````-:``:o:`s`----:-----++o/:os+:::+/-:.--/y:------++++o`:-`+md+:sdNNNdo.``:o/`+++++++ooysso++++ss++o+++++++-s+s////::-.'
echo '````sy+:o/`+s.----/-----+++o.oss/---o`---:-+s----:/+++++`.`-my.-NMMMNNNNd-   .``s+++++s+y-``-+o++++++o++++++:o+s...`````'
echo '```-ddhssy`yo.-:--o-//--++os``+s+/:-+-`----:/o::/+++++++ `.hh``oMMMNNNmddd-     ++++++o+s-..` :+++++++++++++//os.```````'
echo '``-hddddds:ho--+:-s:+o--+++s```/+/+::+``-://o-s++++++++/```+.  /MMmhyoooooy`    -s++++s+s+/.-- `o+++++o++++++:so/``````:'
echo '/+yddddddsods--++-o/+s--+++o-` `-:///++:-./+++.oo++++++-`  `    dho+ooo//+s:    `s++++o+oo//`.- +++++++++++++:o++``````-'
echo ':odddddddyydy--/o:o+/o+-/++++..:ymdysooo+/::+o:`/s+++//`        .yo///::::s:``   s++++ooos..-`. /o+++++o+++++//ss``````:'
echo 'oddddddddhydd--/oso:o+s::+++s`+md/.-smmmy+..`:+- `//-.`          .so/:::+so:.``` +o+++so++:.-`` ++++++++o+++++:ss``````:'
echo 'ddddddddddhdd/-:ooy-++oo-/++o:hm:``yMMMNNNy`  `-`  `              `/ossso/-```   :s+++so+o--``-`s+++++++/+++++/oy``````:'
echo 'dhs+sddddddmdy:-/+s+:o+s+-/++ssd.` sMMNNmmds    `                `.---..````     -s+++so+o:``-.:s+++++++//+++++/h:`````-'
echo '/.```:hddddddd+:-++o//ooso:/+s+s.  -NNdhsooy/                                    -+++oso+o.`.-`s++++++++/-/++++/ss-````.'
echo '`.----:yddyooss/::++o++ooso//+y-.   +hooo+++s`                                  `.:o+os++o-.:`+o+++o+++++:-+++++/yo:---:'
echo '///::::/y+::::+o+/:/+o+ooosso+oo`    +s+/:::+:                                  .`.s+os++o:.`/s++++o+++++/-:++++/soo/:::'
echo ':::::::::::::::++++/+++oooossysso`    :s+///:.   ```                            - `s+os++o.`:so+++++o+++++--:++++/s+o/::'
echo '::::::::::::::::/o+ooo++osooosyhho`  `.-+/-.`    `-`                           .`  s+ss++o:+++o++++//o++++/--:+++/o++o/:'
echo '....-::::::::::::/ooosso++ssoosyyho``....``                    ``..-:/-`      `.   o+so++oso++o++++/-+++++o---/+++:o++o/'
echo '--.`````..---::::::/ooosyo++osoossy+``````                ````..------:/`    `.    +oso++oso+oo+++++-:o+++o:---/++/o+::+'
echo '....```````````...-:/+/oos+/+++++osh:                 ``....-------....-/    .     /ss+++oso+os+++++:-:o++++----++++o---'
echo '``````````````````-:-```-/++:-/so++oy`              `-:------...````````:   `      :ss+++oso++s+++++/--:o++o:----+++o:--'
echo '````````````````.--``````````-sy+://s-              +:---..``````````````         .yys+++sss++ss+++++:--:o+++----:+++/--'
echo '..``````````````.```````````-sss/---/o              ./-.`````````````           `---yo+++sss++oso//++/---:++o:----:+++/-'
echo '///-```````````````````````.ss/:/---://`             .-.````````              `:-``.yo+++osy++:-.` `-+:----++o-----:+++/'
echo ':::++/.```````````````````.oo/-o:---/-yo-`             ...`                 `--`````so+++sso:-.`.`   `/:---:/+/-----:+++'
echo '::::+oss/.```````````````.oo:.`+---::-sooo+:`                             .:-```````s+++o:.   .:s/`    :syo:/+/+:----:++'
echo '::::/oooss/```````````---/+-``.o---::-sso++oso+:``                     `-//.```````.so/`.::.`   .o/.    -o-::`  :+:---:+'
echo ':::::+ooooo:....--+sh:.`-+:```-/---/--sss++++++osso+/-`             `-++:-.``````-:/o.`    -:-     ..`   `-/`    `//---:'
echo ':::::/oooooo``.```-md```+/````+:---/--ysso+++++o++++osso+/:-.`   `:os+::-.````.:/-:::---     `.           `-`   `  .+:--'
echo '::::::ooooos.      +y``-//```.+----o--ysss+++++oo+++os++++osssssssd/:::-````:/:..:.`` `-:.`             ```-  `     `+--'
echo 'o/:::/ooooos:-..`  `s``/-/```+:---/+--ysss+++++yo+++os++++sysssssos/::-``-//-...:.`..     .`        ```````-`         ::'
echo 'os+ooooooooo.  `.-.`/`./-/``-/----++--hssso++++oo++oss++++ssssso:.-o:--:/:.....-:.::+-             ```````-.           +'
echo 'os+oysssos/   ```--::-:/-/`./----:o+--hssso+++o:s++oss+++ossss....:s:-.```..----:-.-://       ````````````/    `.`     `'
echo '+so+oo+sy:   `-/-`   `/+:/-::----+++-/hssso++++-o+osso+++oyss. -.:.`          --.-:::+`     `````````````..  `.-.       '
echo 'oos++y+o-   `-:`   ``.:/..++----:o++-oyssss++o-:oosss+++oss+:`od+-./`         --..../-     ``````````````: `..-`        '
echo 'oos++so.  `..`    `-:-`  `.o:--:o+++-ysssss++/`/oosss+oydmo-/ooo++yhy`        :....:/      `````````````-.`..-`         '
echo '+os+++`  ..`    `--.`   `.--/:-++++/:dsssss+o.`oossyhdmNmo-+++++++syho       `:..:yh`     ``````````````/...-`.`        '
echo 'oysoo-   `    `--`    `.-.`  -++++o:+hssssoo-`.yhdmNNNNh-`++++++osyys-:      --:sddo     ``````````````:-..-`..         '




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

# sudo apt update        # Fetches the list of available updates
# sudo apt upgrade -y       # Installs some updates;
# sudo apt full-upgrade -y  # Installs updates; may also remove packages
# sudo apt autoremove -y    # Removes any old packages that are no longer needed

alias henshin="sudo -- sh -c 'sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y;'"

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
# eval "$(ssh-agent -s)"

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
