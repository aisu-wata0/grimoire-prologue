#!/bin/bash

cat_random_file_art() {
  # Check if directory path is provided as an argument
  if [ $# -eq 0 ]; then
    return 1
  fi

  # Use find with -type f and pipe to shuf
  file=$(find $1 -type f | shuf -n 1)

  # Check if there are any files
  if [ -z "$file" ]; then
    return 1
  fi

  # Extract filename from path using basename
  filename=$(basename "$file")
  echo "$filename"
  # Print the content of the random file
  cat "$file"
}
