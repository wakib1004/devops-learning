#Level 8: Multi-File Searcher
#Outputs the names of the .log files in a directory that contain a specific word.

#!/bin/bash

directory="Arena"
word="line"

#Ouputs .log files in Arena that contain the word, if any file contain it.
grep -l "$word" "$directory"/*.log
exit_code=$?

#Prints feedback message if the word was not found.
if [ $exit_code -ge 1 ]; then
  echo "The word/phrase "$word" does not exist in any .log files in this directory"
fi
