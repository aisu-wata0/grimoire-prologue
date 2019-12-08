#!/bin/bash

# Prints all the commands to link the files of this repository to your home directory.

fn(){
	filename="$1"
	./scripts/make_link.sh "${filename}" ~/"${filename}"
}

for filename in ./.[!.]*; do
	fn "${filename}"
done

for filename in ./*; do
	fn "${filename}"
done