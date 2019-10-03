echo "source .profile"

export LANG=en_US.UTF-8

export PIP_DEFAULT_TIMEOUT=1000

export PATH="~/scripts/:$PATH"
export PYTHONPATH="~/scripts/:$PYTHONPATH"

export PATH="~/.local/bin:$PATH"
export PATH="~/nobackup/VSCode-linux-x64:$PATH"

export PATH=/home/soft/likwid/bin:/home/soft/likwid/sbin:$PATH

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"


# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
