#Level 3: Conditional Statements
:'
A script that checks if a file named hero.txt exists in the Arena
directory. If it does, print "Hero found!"; otherwise, print "Hero missing!". 
'
 
#!/bin/bash

if [ -f Arena/hero.txt ]; then
  echo "Hero found!"
else
  echo "Hero missing!"
fi
