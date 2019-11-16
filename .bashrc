
###
if [ ! $DOT_BASHRC_SOURCED ]; then

echo "source .barshrc"
export DOT_BASHRC_SOURCED=0

test -f ~/.bash_custom.sh && . ~/.bash_custom.sh

# END if [ ! $DOT_BASHRC_SOURCED ]; then
fi
