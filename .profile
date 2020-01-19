if [ ! $DOT_PROFILE_SOURCED ]; then


# echo "source .profile"
DOT_PROFILE_SOURCED=0

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

export LANG=en_US.UTF-8

export PIP_DEFAULT_TIMEOUT=1000

export PATH="~/scripts/:$PATH"
export PATH="~/scripts/video-downplay/:$PATH"
export PYTHONPATH="~/scripts/:$PYTHONPATH"
export PYTHONPATH="~/scripts/video-downplay/:$PYTHONPATH"

export PATH="~/.local/bin:$PATH"
export PATH="~/nobackup/VSCode-linux-x64:$PATH"

export PATH=/home/soft/likwid/bin:/home/soft/likwid/sbin:$PATH

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Cuda CUPTI
export CUDA_HOME="/usr/local/cuda/"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/extras/CUPTI/lib64"

# END if [ ! $DOT_PROFILE_SOURCED ]; then
fi