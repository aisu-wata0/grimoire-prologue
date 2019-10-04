
# dotfiles and scripts

Uses GNU Stow – https://www.gnu.org/software/stow/

Usage:

clone the repository  
cd to repository directory

```bash
stow . -t ~
```

This creates symbolic links of these files and dirs in the home directory

If this error occurs

```bash
WARNING! stowing . would cause conflicts:                                                                * existing target is neither a link nor a directory: .bashrc
  * existing target is neither a link nor a directory: .gitconfig
  * existing target is neither a link nor a directory: .profile
All operations aborted.
```

Delete the files with conflict (.bashrc etc.), of course make sure you're not deleting anything important.

--------------------

Idea from <https://github.com/notthebee/dotfiles>.  
Video about it: <https://www.youtube.com/watch?v=MJBVA4LeJKA>.  
