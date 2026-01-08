#Level 10 - Boss Battle




#!/bin/bash

mkdir Arena_Boss
mkdir Victory_Archive

#Generates 5 files in the directory, named file1txt to file5.txt
#Adds a random number of lines (between 10 and 20) to each of those files
for number in {1..5}; do
        touch Arena_Boss/file"$number"
        random_num=$(shuf -i 11-19 -n 1)

        for (( i=1; i<=$random_num; i++ )); do
                echo "This is line $i" >> Arena_Boss/file$number
        done
done

ls -S Arena_Boss

if grep -q Victory Arena_Boss/*; then
        cd ~/Arena_Boss
        files_with_string=$(grep -l "Victory" *)

        for file_with_string in $files_with_string; do
                mv $file_with_string ~/Victory_Archive/$file_with_string
        done
        cd ..
fi
