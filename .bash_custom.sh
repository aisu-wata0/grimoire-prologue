
###

HISTSIZE=20000
HISTFILESIZE=20000

export PIP_DEFAULT_TIMEOUT=1000

export PATH="~/nobackup/VSCode-linux-x64:$PATH"
export PATH=/home/soft/likwid/bin:/home/soft/likwid/sbin:$PATH
export PATH="~/nobackup/VSCode-linux-x64:$PATH"
export NVM_DIR="/home/bfs15/.nvm"

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Load RVM into a shell session *as a function*

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# GIT PS1
if [ ! -f ~/.bash_git ]; then
    echo "~/.bash_git not found, downloading"
    curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
fi

GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true

source ~/.bash_git
# SSH AGENT for ssh keys
eval "$(ssh-agent -s)"

#[usr@machine] [path] $
#
PS1='\n${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] $(date +%Y%m%d-%H%M) \[\033[01;34m\][\w]\e[0m$(__git_ps1) \$\n'
PROMPT_COMMAND='__git_ps1 "\n${debian_chroot:+($debian_chroot)}\033[33;1m[\u@\h] $(date +%Y%m%d-%H%M) \[\033[01;34m\][\w]\e[0m" " \\\$\n"'

# Set Git language to English
alias git='LANG=en_GB git'
#alias git='LC_ALL=en_GB git'


alias appget="sudo aptitude"
# some more ls aliases
alias ll='ls -lh'
alias la='ls -lhA'
alias lt='ls -lht'


# tab size
tabs -3