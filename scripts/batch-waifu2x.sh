#!/bin/bash

set -o xtrace

for noise_lvl in 2 3; do
	cp -r "$1 in" $noise_lvl/
	
	for f in  $noise_lvl/*; do
		./waifu2x-caffe-cui.exe -i "$f" -m noise_scale --scale_ratio 2 --noise_level $noise_lvl
		rm "$f"
		echo ""
	done
done

echo ""
echo "moving files from 3/ to \"$1 est\"/"
if [ ! -d "$1 est" ]; then
	mkdir "$1 est"
fi
mv 3/* "$1 est"
rmdir 3/

echo ""
echo "renaming files in \"$1 est\"/"
for f in "$1 est"/*; do
	if [ ! "$f" == "${f/(UpRGB)(noise_scale)(Level3)(x2.000000)/-est}" ]; then
		mv "$f" "${f/(UpRGB)(noise_scale)(Level3)(x2.000000)/-est}"
	fi
done


echo ""
echo "moving files from 2/ to \"$1 hi\"/"
if [ ! -d "$1 hi" ]; then
	mkdir "$1 hi"
fi
mv 2/* "$1 hi"
rmdir 2

echo ""
echo "renaming files in \"$1 hi\"/"
for f in "$1 hi"/*; do
	if [ ! "$f" == "${f/(UpRGB)(noise_scale)(Level2)(x2.000000)/-hi}" ]; then
		mv "$f" "${f/(UpRGB)(noise_scale)(Level2)(x2.000000)/-hi}"
	fi
done
