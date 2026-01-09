#Level 5: The Boss Battle - Combining Basics
:' 
-Script that creates "Battlefield" directory and 3 files within it.
-If "knight.txt" file exists in the directory, then creates an "Archive" directory and moves
the file into it.
-Displays the contents of both "Battlefield" and "Archive" directory.
'

#!/bin/bash

mkdir Battlefield
cd Battlefield
touch knight.txt sorcerer.txt rogue.txt

if [ -f Battlefield/knight.txt ]; then
  mkdir Archive
  mv knight.txt Archive/knight.txt
fi

echo "Contents of Battlefield:"
ls Battlefield 
echo "Content of Archive:"
ls Archive
