#Level 6 - Argument Parsing
:' A Script that accepts a filename as an argument and prints the number of lines in that file.
-If no filename is provided, displays a message saying "No file provided".
'
#!/bin/bash

#Checks if an argument was provided
if [ $# -eq 0 ]; then
 echo "No filename provided"
    exit 1
fi

filename="$1"

if [ ! -f "$filename" ]; then
  echo "File not find"
  exit 1
fi

num_of_lines=$(cat "$filename" | wc -l)
echo "The number of lines in the file is: $num_of_lines"

