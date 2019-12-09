git clone https://github.com/powerline/fonts.git --depth=1
# Update submodules
git submodule update --init --recursive
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

stow . -t ~