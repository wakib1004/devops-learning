:'
Creates a directory named bash_demo and navigates into it 
and creates the file "demo.txt"
writes text to that file(including current date)
and displays the content of the file
'
#!/bin/bash

directory="bash_demo"
demo_file="demo.txt"

#create directory
mkdir "$directory"
echo "Directory named bash_demo was created"

#create demo.txt file
cd "$directory"
touch "$demo_file"
echo "File demo.txt was created"

echo "This file was created by a Bash script on: $(date '+%Y-%m-%d')" >> "$DEMO_FILE"
cat $demo_file
