#Level 10 - Boss Battle
:'
1. Creates a directory called Arena_Boss.
2. Creates 5 text files inside the directory, named file1.txt to file5.txt.
3. Generates a random number of lines (between 10 and 20) in each file.
4. Sorts these files by their size and displays the list.
5. Checks if any of the files contain the word "Victory", and if found, moves the file to a directory called Victory_Archive.
'

#!/bin/bash

mkdir Arena_Boss
mkdir -p Victory_Archive

#Creates 5 files in the directory, named file1txt to file5.txt
#Generates a random number of lines (between 10 and 20) to each of those files
for number in {1..5}; do
        touch Arena_Boss/file"$number"
        random_num=$(shuf -i 11-19 -n 1)

        for (( i=1; i<=$random_num; i++ )); do
                echo "This is line $i" >> Arena_Boss/file$number
        done
done

#Sorts these files by their size and displays the list.
ls -S Arena_Boss

#Moves any of these files to Victory_Archive if it contains the word "Victory"
if grep -q Victory Arena_Boss/*; then
        cd ~/Arena_Boss
        files_with_string=$(grep -l "Victory" *)

        for file_with_string in $files_with_string; do
                mv $file_with_string ~/Victory_Archive/$file_with_string
        done
        cd ..
fi
