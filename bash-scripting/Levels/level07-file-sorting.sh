#Level 7: File Sorting Script
#A Script that displays all .txt files in "Arena" directory by their size, from the smallest to largest with sizes mentioned.

dir_name="Arena"

if [ ! -d "$dir_name" ]; then 
  echo "Directory "$dir_name" does not exist"
  exit 1
fi

#Prints names and sizes in the above order.
ls -Srl Arena/*.txt | awk '{print $5, $9}'
