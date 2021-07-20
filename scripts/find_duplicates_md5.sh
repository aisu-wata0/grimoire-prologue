#!/bin/bash
# Finds duplicate files of all files in the tree based on md5,slow but the best
find . ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD