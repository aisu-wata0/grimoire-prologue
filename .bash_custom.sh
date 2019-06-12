
test -f ~/.profile && . ~/.profile

## aliases
alias appget="sudo aptitude"
# ls aliases
# h = readable file size
alias ll='ls -lh'
# S = sort by file size
alias lhs='ls -lhS'
# A = list all
alias la='ls -lhA'
# t = sort my modification date
alias lt='ls -lht'
## aliases

# tab size
tabs -3

# 100K lines is around one 10MB
HISTSIZE=100000
HISTFILESIZE=100000

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

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
PS1='\n${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] $(date +%Y%m%d-%H%M) \[\033[01;34m\][\w]\e[0m$(__git_ps1) \$\n'
PROMPT_COMMAND='__git_ps1 "\n${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] $(date +%Y%m%d-%H%M) \[\033[01;34m\][\w]\e[0m" " \\\$\n"'


# mouse acc
# https://forums.linuxmint.com/viewtopic.php?t=208817
# https://wiki.archlinux.org/index.php/Mouse_acceleration
# ignore errors
xinput --set-prop 11 "Device Accel Velocity Scaling" 1 2>  /dev/null
xinput --set-prop 11 "Device Accel Profile" -1 2>  /dev/null
xinput --set-prop 11 "Device Accel Adaptive Deceleration" 4 2>  /dev/null
