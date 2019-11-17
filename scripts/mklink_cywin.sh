#! bash

# We still need this.
windows() { [[ -n '$WINDIR' ]]; }

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
make_link() {
	if [[ -z "$2" ]]; then
		# Link-checking mode.
		echo Link-checking mode.
		if windows; then
			echo fsutil reparsepoint query "$1" > /dev/null
			fsutil reparsepoint query "$1" > /dev/null
		else
			[[ -h "$1" ]]
		fi
	else
		# Link-creation mode.
		echo Link-creation mode.
		if windows; then
			# Windows needs to be told if it's a directory or not. Infer that.
			# Also: note that we convert `/` to `\`. In this case it's necessary.
			echo windows
			if [[ -d "$2" ]]; then
				echo cmd \<\<\< "mklink /D "${1//\//\\}" "${2//\//\\}""
				# cmd <<< "mklink /D "${1//\//\\}" "${2//\//\\}""
			else
				echo cmd \<\<\< "mklink "${1//\//\\}" "${2//\//\\}""
				# cmd <<< "mklink "${1//\//\\}" "${2//\//\\}""
			fi
		else
			# You know what? I think ln's parameters are backwards.
			echo ln -s "$2" "$1"
			# ln -s "$2" "$1"
		fi
	fi
}

path_link=$1
path_target=$2

if windows; then
	path_link=$(cygpath -d "${path_link}")
	path_target=$(cygpath -d "${path_target}")
fi

if [[ -z "$2" ]]; then
	echo link.sh 'link' 'target'
else
	make_link ${path_link} ${path_target}
fi