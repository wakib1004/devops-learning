:'
Creates a script that prompts for a filename, checks if it exists,
and reports its read, write, and execute permissions.
'
#!/bin/bash

echo "Enter filename to check:"
read filename

#Checks if file exists and exits if it does not.
if [ -f "$filename" ]; then
  echo "File "$filename" exists"
else
  echo "File "$filename" does not exist"
 exit 1
fi

#Checks if a file contains a specific permission
#Arguments: $1 - specifc permission (r,w,x). $2 - full name of the permission
check_permissions() {
 local perm_to_check="$1"
 local perm_full_name="$2"
 local perms=$(ls -l "$filename" | awk '{print $1}')
 
 if [[ "$perms" == *"$perm_to_check"* ]]; then
  echo "File is $perm_full_name"
 else
  echo "File is not $perm_full_name"
 fi
}

check_permissions "r" "readable"
check_permissions "w" "writable"
check_permissions "x" "executable"
