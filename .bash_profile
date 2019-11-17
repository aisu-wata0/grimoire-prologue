
if [ ! $DOT_BASHPROFILE_SOURCED ]; then

echo "source .bash_profile"
export DOT_BASHPROFILE_SOURCED=0

if [ ! $DOT_PROFILE_SOURCED ];
    then
    echo "      .bash_profile: profile"
    test -f ~/.profile && . ~/.profile;
fi
if [ ! $DOT_BASHRC_SOURCED ];
    then
    echo "      .bash_profile: bashrc"
    test -f ~/.bashrc && . ~/.bashrc;
fi
if [ ! $DOT_BASHPROFILE_SOURCED ];
    then
    echo "      .bash_profile: bash_profile"
    test -f ~/.bash_profile && . ~/.bash_profile;
fi

# .profile sources bashrc
# test -f ~/.bashrc && . ~/.bashrc

# Auto start ssh-agent if necessary
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
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

# END if [ ! $DOT_BASHPROFILE_SOURCED ]; then
fi