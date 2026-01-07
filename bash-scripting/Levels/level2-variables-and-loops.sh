#Level 2: Variables and Loops
#A script that outputs the numbers 1 to 10, one number per line

#!/bin/bash

num=1

#Ouputs numbers 1 to 10 
while [ $num -lt 11 ]; do
  echo "$num"
  ((num++))
done
