#! bash

# We still need this.
windows() { [[ -n '$WINDIR' ]]; }

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
make_link() {
	path_target="$1"
	path_link="$2"
	if [[ -z "$path_target" ]]; then
		# Link-checking mode.
		echo Link-checking mode.
		if windows; then
			echo fsutil reparsepoint query "${path_link}" > /dev/null
			fsutil reparsepoint query "${path_link}" > /dev/null
		else
			[[ -h "${path_link}" ]]
		fi
	else
		# Link-creation mode.
		if windows; then
			# Windows needs to be told if it's a directory or not. Infer that.
			# Also: note that we convert `/` to `\`. In this case it's necessary.
			if [[ -d "$path_target" ]]; then
				echo 'cmd <<< "'"mklink /D "${path_link//\//\\}" "${path_target//\//\\}""\"
				# cmd <<< "mklink /D "${path_link//\//\\}" "${path_target//\//\\}""
			else
				echo 'cmd <<< "'"mklink "${path_link//\//\\}" "${path_target//\//\\}""\"
				# cmd <<< "mklink "${path_link//\//\\}" "${path_target//\//\\}""
			fi
		else
			# Unix
			echo ln -s "${path_target}" "${path_link}"
			# ln -s "${path_target}" "${path_link}"
		fi
	fi
}

path_target="$1"
path_link="$2"

if windows; then
	path_target=$(cygpath -wal "${path_target}")
	path_link=$(cygpath -wal "${path_link}")
fi

if [[ -z "$1" ]]; then
	echo link.sh 'link' 'target'
else
	make_link "${path_target}" "${path_link}"
fi