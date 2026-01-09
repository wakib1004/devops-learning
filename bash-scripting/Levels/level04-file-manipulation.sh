#Level 4 - File Manipulations
#A Script that copies all .txt files from the Arena directory to a new directory called Backup.

#!/bin/bash

mkdir -p ~/Backup
cp ~/Arena/*.txt ~/Backup
