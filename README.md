
# dotfiles and scripts

## Linux

Uses GNU Stow – <https://www.gnu.org/software/stow/>

Usage:

clone the repository  
cd to repository directory
create symlinks to files

```bash
git clone git@github.com:bfs15/grimoire-prologue.git
cd grimoire-prologue
stow . -t ~
```

stow creates symbolic links of these files and dirs in the home directory

If the following error occurs:

```bash
WARNING! stowing . would cause conflicts:                                                                * existing target is neither a link nor a directory: .bashrc
  * existing target is neither a link nor a directory: .gitconfig
  * existing target is neither a link nor a directory: .profile
All operations aborted.
```

Delete the files with conflict (.bashrc etc.), of course make sure you're not deleting anything important.

----------------------------

## Windows

If you use git bash dotfiles might be useful

To create symlinks you need to do these comands on the cmd; you could make this a automatic batch script that loops over files.

If you are in the possession of the Grimoire, you can do this to generate the spells above

```bash
create_file_links.sh # this just prints the commands, since you need cmd and adm permissions on windows
```

Else you need to do this to add the files manually

```batch
mklink c:\Users\bruno\.bash_custom.sh  e:\Users\Serbena\Git\grimoire-prologue\.bash_custom.sh
mklink c:\Users\bruno\.bash_git  e:\Users\Serbena\Git\grimoire-prologue\.bash_git
mklink c:\Users\bruno\.bash_profile  e:\Users\Serbena\Git\grimoire-prologue\.bash_profile
mklink c:\Users\bruno\.bashrc  e:\Users\Serbena\Git\grimoire-prologue\.bashrc
mklink c:\Users\bruno\.condarc  e:\Users\Serbena\Git\grimoire-prologue\.condarc
mklink c:\Users\bruno\.gitconfig  e:\Users\Serbena\Git\grimoire-prologue\.gitconfig
mklink c:\Users\bruno\.minttyrc  e:\Users\Serbena\Git\grimoire-prologue\.minttyrc
mklink c:\Users\bruno\.profile  e:\Users\Serbena\Git\grimoire-prologue\.profile
mklink C:\Users\bruno\.tmux.conf E:\Users\Serbena\Git\grimoire-prologue\.tmux.conf
mklink /D c:\Users\bruno\scripts\  e:\Users\Serbena\Git\grimoire-prologue\scripts\
mklink /D c:\Users\bruno\.ascii\  e:\Users\Serbena\Git\grimoire-prologue\.ascii\
```


----------------------------

Idea from <https://github.com/notthebee/dotfiles>.  
Video about it: <https://www.youtube.com/watch?v=MJBVA4LeJKA>.  
