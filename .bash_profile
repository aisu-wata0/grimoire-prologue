
if [ ! $DOT_BASHPROFILE_SOURCED ]; then

# echo "source .bash_profile"
DOT_BASHPROFILE_SOURCED=0

if [ ! $DOT_PROFILE_SOURCED ]; then
    echo "      .bash_profile: profile"
    . ~/.profile 2> /dev/null;
fi
if [ ! $DOT_BASHRC_SOURCED ]; then
    echo "      .bash_profile: bashrc"
    . ~/.bashrc 2> /dev/null;
fi
if [ ! $DOT_BASHPROFILE_SOURCED ]; then
    echo "      .bash_profile: bash_profile"
    . ~/.bash_profile 2> /dev/null;
fi


# END if [ ! $DOT_BASHPROFILE_SOURCED ]; then
fi