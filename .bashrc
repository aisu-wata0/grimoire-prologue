
###
if [ ! $DOT_BASHRC_SOURCED ]; then

# echo "source .barshrc"
export DOT_BASHRC_SOURCED=0

. ~/.bash_custom.sh 2> /dev/null

# END if [ ! $DOT_BASHRC_SOURCED ]; then
fi
